// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"

//IMPORTANT: LOGFILE MUST BE REMOVED BEFORE BUILDING THIS FOR PRODUCTION
//#define LOGFILE "c:\\PasswordFilter.txt"

//define error codes for the application
#define DB_ERROR_CONNECTION 1
#define DB_ERROR_AUTOCOMMIT 2
#define DB_ERROR_QUERY		3
#define CURL_ERROR			4
#define UNSUCCESSFUL		0xC0000001

//define success codes
#define DB_SUCCESS_UUID_CREATED 0
#define CURL_SUCCESS			0
#define SUCCESS					0x00000000

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

/**
 * This function will write to a log the system date and time as well
 * as the username and password.
 */
void WriteToLog (const wchar_t* Message)
{
#ifdef LOGFILE
	FILE* log = fopen(LOGFILE, "a");
	
	INT currTimeStringLen = GetTimeFormatEx(
		LOCALE_NAME_SYSTEM_DEFAULT,
		NULL,
		NULL,
		L"hh':'mm':'ss tt",
		NULL,
		0);

	LPWSTR currTimeString = new wchar_t[currTimeStringLen];
	GetTimeFormatEx(
		LOCALE_NAME_SYSTEM_DEFAULT,
		NULL,
		NULL,
		L"hh':'mm':'ss tt",
		currTimeString,
		currTimeStringLen);

	INT currDateLen = GetDateFormatEx(
		LOCALE_NAME_SYSTEM_DEFAULT,
		NULL,
		NULL,
		L"yyyy'-'MM'-'dd",
		NULL,
		0,
		NULL);

	LPWSTR currDateString = new wchar_t[currDateLen];
	GetDateFormatEx(
		LOCALE_NAME_SYSTEM_DEFAULT,
		NULL,
		NULL,
		L"yyyy'-'MM'-'dd",
		currDateString,
		currDateLen,
		NULL);

	if(NULL == log)
	{
		return;
	}

	fwprintf(log, L"(%s %s) %s\r\n",
		currDateString, currTimeString, Message);
	fclose(log);
	delete [] currDateString;
	delete [] currTimeString;
#endif
	return;
}

/**
 * This function writes a reset check record out on sumac and populates a c-string
 * with the uuid that was created for use in other parts of the application.
 *
 * Returns an integer value indicating a failure or success.
 */
INT writeDbRecord (LPWSTR *resetUuid)
{
	RETCODE rc;		//ODBC return code
	HENV henv;		//environment handle
	HSTMT hstmt;	//statement handle
	HDBC hdbc;		//connection handle
	//SDWORD cbData;	//Debug code used for select statements

	//Allocate the environment handle and the connection handle
	SQLAllocEnv(&henv);
	SQLAllocConnect(henv, &hdbc);

	//connect to summac
	rc = SQLDriverConnect(
		hdbc,
		NULL,
		(SQLWCHAR*)L"DRIVER={SQL Server};SERVER=sumac.conncoll.edu,1433;DATABASE=camel2;UID=camel_web;PWD=!Camel09;",
		SQL_NTS,
		NULL,
		0,
		NULL,
		SQL_DRIVER_COMPLETE);

	//if no connection is made terminate the execution
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
	{
		return DB_ERROR_CONNECTION;
	}

	//enable auto-commits
	rc = SQLSetConnectAttr( hdbc, SQL_ATTR_AUTOCOMMIT, (SQLPOINTER) TRUE, 0);

	//if we cannot turn on auto-commits terminate the execution
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
	{
		return DB_ERROR_AUTOCOMMIT;
	}

	//create a uuid string
	UUID uuid;
	UuidCreate(&uuid);
	RPC_WSTR uuidStr;
	UuidToStringW(&uuid, &uuidStr);

	//add quotes to uuid string
	size_t quotedUuidSize = wcslen((wchar_t*)uuidStr) + 2;
	LPWSTR quotedUuidStr = new wchar_t[quotedUuidSize + 1];
	memset(quotedUuidStr, 0, sizeof(wchar_t) * quotedUuidSize + 1);
	wcscat(quotedUuidStr, L"'");
	wcscat(quotedUuidStr, (wchar_t*)uuidStr);
	wcscat(quotedUuidStr, L"'");

	//admin_user variable
	LPWSTR adminUser;
	adminUser = L"'Active Directory'";

	//create a query string
	LPWSTR sql = L"INSERT INTO cw_ResetCheck (ResetUID, AdminUser ) values (";
	size_t queryStrSize = wcslen(sql) + wcslen((wchar_t*)quotedUuidStr) + wcslen(adminUser) + 2;
	LPWSTR queryStr = new wchar_t[queryStrSize + 1];
	memset(queryStr, 0, sizeof(wchar_t) * (queryStrSize + 1));
	wcscat(queryStr,sql);
	wcscat(queryStr,(wchar_t*)quotedUuidStr);
	wcscat(queryStr,L",");
	wcscat(queryStr,adminUser);
	wcscat(queryStr,L")");

	//allocate the statement handle and execute the query
	rc = SQLAllocHandle(SQL_HANDLE_STMT, hdbc, &hstmt);
	rc = SQLExecDirect(hstmt, (SQLWCHAR*)queryStr, SQL_NTS);

	//if the query fails terminate execution
	if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO))
	{
		SQLFreeStmt(hstmt,SQL_DROP);
		SQLDisconnect(hdbc);
		SQLFreeConnect(hdbc);

		//delete strings
		delete [] quotedUuidStr;
		delete [] queryStr;

		return DB_ERROR_QUERY;
	} 
	else
	{
		size_t resetUuidLen = wcslen((wchar_t*)uuidStr);
		*resetUuid = new wchar_t[resetUuidLen + 1];
		memset(*resetUuid, 0, sizeof(wchar_t) * (resetUuidLen + 1));
		wcscpy(*resetUuid, (wchar_t*)uuidStr);
	}

	//close database
	SQLFreeStmt(hstmt,SQL_CLOSE);
	SQLDisconnect(hdbc);
	SQLFreeConnect(hdbc);
	
	//delete strings
	delete [] quotedUuidStr;
	delete [] queryStr;

	return DB_SUCCESS_UUID_CREATED;
}


/**
 * This function is used to suppress output from the curl function calls.
 */
size_t write_data(void *buffer, size_t size, size_t nmemb, void *userp)
{
	return size * nmemb;
}

/**
 * This function will create a curl request with a given resetUuid, username,
 * and password.
 * 
 * Returns an integer value indicating failure or success.
 */
INT casCurlRequest(LPWSTR resetUuid, LPWSTR username, LPWSTR newPassword)
{
	CURL *curl = curl_easy_init();
	CURLcode response;
	INT rc;

	//set the URL for the restlet
	curl_easy_setopt(curl, CURLOPT_URL, "http://cas.conncoll.edu/cas/cas-rest-api/reset/");

	//create the json string
	LPWSTR jsonStr = L"{\"uname\" : ";
	LPWSTR jsonPassword = L"\"password\" : ";
	LPWSTR jsonSec = L"\"sec\" : ";
	LPWSTR jsonSetAD = L"\"setAD\" : ";
	LPWSTR jsonEnforce = L"\"enforce\" : ";
	size_t jsonRequestStrLen = wcslen(jsonStr) + wcslen(username) + wcslen(jsonPassword) + 
							   wcslen(newPassword) + wcslen(jsonSec) + wcslen(resetUuid) + 
							   wcslen(jsonSetAD) + (wcslen(L"false") * 2) + (wcslen(L"\",") * 3) + 
							   (wcslen(L"\"") * 3)  + wcslen(jsonEnforce) + wcslen(L"}") + wcslen(L",");
	LPWSTR jsonRequestStr = new wchar_t[jsonRequestStrLen + 1];
	memset(jsonRequestStr, 0, sizeof(wchar_t) * (jsonRequestStrLen + 1));
	wcscat(jsonRequestStr, jsonStr);
	wcscat(jsonRequestStr, L"\"");
	wcscat(jsonRequestStr, username);
	wcscat(jsonRequestStr, L"\",");
	wcscat(jsonRequestStr, jsonPassword);
	wcscat(jsonRequestStr, L"\"");
	wcscat(jsonRequestStr, newPassword);
	wcscat(jsonRequestStr, L"\",");
	wcscat(jsonRequestStr, jsonSec);
	wcscat(jsonRequestStr, L"\"");
	wcscat(jsonRequestStr, resetUuid);
	wcscat(jsonRequestStr, L"\",");
	wcscat(jsonRequestStr, jsonSetAD);
	wcscat(jsonRequestStr, L"false");
	wcscat(jsonRequestStr, L",");
	wcscat(jsonRequestStr, jsonEnforce);
	wcscat(jsonRequestStr, L"false");
	wcscat(jsonRequestStr, L"}");

	INT multiLen = WideCharToMultiByte(
		CP_ACP,
		0,
		jsonRequestStr,
		-1,
		NULL,
		0,
		NULL,
		NULL);
	LPSTR jsonRequestStrConverted = new char[multiLen];
	WideCharToMultiByte(
		CP_ACP,
		0,
		jsonRequestStr,
		-1,
		jsonRequestStrConverted,
		multiLen,
		NULL,
		NULL);

	struct curl_slist *headers = NULL;
	headers = curl_slist_append(headers, "Accept: application/json");
	headers = curl_slist_append(headers, "Content-Type: application/json");
	headers = curl_slist_append(headers, "charsets: utf-8");

	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
	curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT, 2);
	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, jsonRequestStrConverted);
	curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, multiLen);
	curl_easy_setopt(curl, CURLOPT_POST, 1);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
	response = curl_easy_perform(curl);

	if (response != CURLE_OK)
	{
		rc = CURL_ERROR;
	}
	else
	{
		rc = CURL_SUCCESS;
	}

	curl_easy_cleanup(curl);
	delete [] jsonRequestStr;
	delete [] jsonRequestStrConverted;

	return rc;
}

/**
 * This function simply extracts the buffer from the PUNICODE_STRINGs that
 * the LSA callback functions use and transfers them to zero terminated 
 * c-strings
 */
VOID ConvertWideChar(PUNICODE_STRING input, LPWSTR *wszString)
{
	INT wszLen = input->Length / sizeof(wchar_t);
	*wszString = new wchar_t[wszLen + 1];
	memset(*wszString, 0, sizeof(wchar_t) * (wszLen + 1));
	wcsncpy(*wszString, input->Buffer,wszLen);
}

/**
 * This function initializes the password filter.
 *
 * This implementation simply returns TRUE (success)
 */
BOOLEAN InitializeChangeNotify(void)
{
	return TRUE;
}

/**
 * This function is called by LSA when a password is successfully 
 * changed.
 *
 * This implementation will grab both the username and password and 
 * create a reset record on Sumac. Then, it will issue a call to the
 * CAS restlet to reset the passwords for the user.
 */
NTSTATUS PasswordChangeNotify(
	PUNICODE_STRING UserName,
	ULONG RelativeId,
	PUNICODE_STRING NewPassword
)
{
	INT returnCode;
	NTSTATUS ntStatus;

	//get username and password variables
	//LPWSTR ConvertedUserName = L"demostud", ConvertedNewPassword = L"P@ssw0rd12";
	LPWSTR ConvertedUserName, ConvertedNewPassword;
	ConvertWideChar(UserName, &ConvertedUserName);
	ConvertWideChar(NewPassword, &ConvertedNewPassword);

	//create a sumac reset check record
	LPWSTR resetUuid;
	returnCode = writeDbRecord(&resetUuid);

	switch (returnCode)
	{
	case DB_ERROR_CONNECTION:
		//WriteToLog(L"Error creating a connection to Sumac.");
		ntStatus = UNSUCCESSFUL;
		break;

	case DB_ERROR_AUTOCOMMIT:
		//WriteToLog(L"Error enabling autocommits.");
		ntStatus = UNSUCCESSFUL;
		break;

	case DB_ERROR_QUERY:
		//WriteToLog(L"Error executing insert query on Sumac.");
		ntStatus = UNSUCCESSFUL;
		break;

	case DB_SUCCESS_UUID_CREATED:
		LPWSTR messageText = L"Successfully created Uuid: ";
		size_t MessageLen = wcslen(messageText) + wcslen(resetUuid);
		LPWSTR Message = new wchar_t[MessageLen + 1];
		memset(Message, 0, sizeof(wchar_t) * (MessageLen + 1));
		wcscat(Message, messageText);
		wcscat(Message, resetUuid);

		//WriteToLog(Message);
		delete [] Message;

		//create a curl request
		returnCode = casCurlRequest(resetUuid, ConvertedUserName, ConvertedNewPassword);

		if (returnCode == CURL_ERROR)
		{
			//WriteToLog(L"Error sending restful request to CAS.");
			ntStatus = UNSUCCESSFUL;
		}
		else if (returnCode == CURL_SUCCESS)
		{
			messageText = L"Successfully reset password for ";
			MessageLen = wcslen(messageText) + wcslen(ConvertedUserName) + 
						 wcslen(ConvertedNewPassword) + wcslen(L" (password: ") + wcslen(L")");
			Message = new wchar_t[MessageLen + 1];
			memset(Message, 0, sizeof(wchar_t) * (MessageLen + 1));
			wcscat(Message, messageText);
			wcscat(Message, ConvertedUserName);
			wcscat(Message, L" (password: ");
			wcscat(Message, ConvertedNewPassword);
			wcscat(Message, L")");

			//WriteToLog(Message);
			delete [] Message;
			ntStatus = SUCCESS;
		}
		break;
	}

	//variable cleanup
	delete [] ConvertedUserName;
	delete [] ConvertedNewPassword;
	if (returnCode == DB_SUCCESS_UUID_CREATED || returnCode == CURL_ERROR || returnCode == CURL_SUCCESS)
	{
		delete [] resetUuid;
	}
	return ntStatus;
}

/**
 * This function is called to validate a new password.
 * LSA calls this function when a password is assigned to a new
 * user or when a password is changed for an existing user.
 *
 * This implementation simply returns TRUE (success)
 */
BOOLEAN PasswordFilter(
	PUNICODE_STRING AccountName,
	PUNICODE_STRING FullName,
	PUNICODE_STRING Password,
	BOOLEAN SetOperation
)
{
	return TRUE;
}