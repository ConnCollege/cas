CREATE DEFINER=`root`@`localhost` PROCEDURE `PECI_Phone_Names`(_STUDENT_PIDM int)
BEGIN
	# Populate temporary table with the distinct list of phone numbers
	CREATE temporary TABLE IF NOT EXISTS `PECI_Phones` AS 
		(SELECT distinct cast(null as CHAR(1)) PECI_PHONE_CODE, cast(null as CHAR(3)) PHONE_CODE, concat_ws('', PHONE_AREA_CODE, PHONE_NUMBER) Phone_Num, 
			cast(null as CHAR(400)) Pref_Name, PHONE_AREA_CODE, PHONE_NUMBER
           FROM cas.cc_gen_peci_phone_data_t 
		  where  (CHANGE_COLS <> 'DELETE' or CHANGE_COLS is null) 
            and  PHONE_CODE not like 'EP_'
            and PHONE_NUMBER <> ''
			and STUDENT_PIDM = _STUDENT_PIDM);
     
     #Update the name where phone belongs to student
	update PECI_Phones 
	 inner join  (Select concat(PREFERRED_FIRST_NAME,' ',PREFERRED_LAST_NAME) STUDENT_PREF_NAME,
                    concat_ws('', p.PHONE_AREA_CODE, p.PHONE_NUMBER) Phone_Num
			   from cc_gen_peci_phone_data_t p
			  inner join cc_stu_peci_students_t s
                 on p.STUDENT_PIDM = s.STUDENT_PIDM
			    and p.PARENT_PPID = '0'
			  where PHONE_CODE Not Like 'EP_'
                and s.STUDENT_PIDM = _STUDENT_PIDM
			  group by PHONE_AREA_CODE, PHONE_NUMBER, PHONE_NUMBER_INTL) student
         on PECI_Phones.Phone_Num= student.Phone_Num
        set PECI_Phones.Pref_Name = student.STUDENT_PREF_NAME;
        
    #Update the phone_code where the number is an connect-ed contact        
    update `PECI_Phones` 
	 inner join cas.cc_gen_peci_phone_data_t phone
	    on Phone_Num = concat_ws('', phone.PHONE_AREA_CODE, phone.PHONE_NUMBER)
	   set PECI_Phones.PECI_PHONE_CODE = 'E',
		   PECI_Phones.PHONE_CODE = phone.PHONE_CODE
	 where phone.PHONE_CODE like 'EP_'
        or (phone.PHONE_CODE = 'EP' and PARENT_PPID = '0');
     
     #Update the name where the phone is a parent.
     update PECI_Phones 
	 inner join (select Group_Concat(distinct concat(PARENT_PREF_FIRST_NAME,' ',PARENT_PREF_LAST_NAME)) PARENT_PREF_NAME,
                    concat_ws('', p.PHONE_AREA_CODE, p.PHONE_NUMBER) Phone_Num
			  from cc_gen_peci_phone_data_t p
			 inner join cc_adv_peci_parents_t par
			    on p.PARENT_PPID = par.PARENT_PPID
			   and p.STUDENT_PIDM = par.STUDENT_PIDM
			 where (par.CHANGE_COLS <> 'DELETE' or par.CHANGE_COLS is null)
			   and (p.CHANGE_COLS <> 'DELETE' or p.CHANGE_COLS is null) 
			   and par.STUDENT_PIDM = _STUDENT_PIDM
			 group by PHONE_AREA_CODE, PHONE_NUMBER) parents
         on PECI_Phones.Phone_Num= parents.Phone_Num
        set PECI_Phones.Pref_Name = concat_ws(',',PECI_Phones.Pref_Name,PARENT_PREF_NAME);
     
     #Update the name where the phone is a contact.
     update PECI_Phones 
	 inner join (select p.STUDENT_PIDM, PHONE_AREA_CODE, PHONE_NUMBER,  
			        Group_Concat(distinct concat(EMERG_PREF_FIRST_NAME,' ',EMERG_PREF_LAST_NAME)) EMERG_PREF_NAME,
                    concat_ws('', p.PHONE_AREA_CODE, p.PHONE_NUMBER) Phone_Num
			   from cc_gen_peci_phone_data_t p
			   left join cc_gen_peci_emergs_t EMERG
			     on p.PARENT_PPID = EMERG.PARENT_PPID
			   and p.STUDENT_PIDM = EMERG.STUDENT_PIDM
			  where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') 
                and (EMERG.CHANGE_COLS <> 'DELETE' or EMERG.CHANGE_COLS is null)
			    and (p.CHANGE_COLS <> 'DELETE' or p.CHANGE_COLS is null) 
			    and EMERG.PARENT_PPID not in (select PARENT_PPID from cc_adv_peci_parents_t where STUDENT_PIDM= _STUDENT_PIDM)
			  group by PHONE_AREA_CODE, PHONE_NUMBER) EMERG
         on PECI_Phones.Phone_Num= EMERG.Phone_Num
        set PECI_Phones.Pref_Name = concat_ws(',',PECI_Phones.Pref_Name,EMERG_PREF_NAME);
    
        
            
	select PECI_PHONE_CODE, PHONE_CODE, Phone_Num, Pref_Name, PHONE_AREA_CODE, PHONE_NUMBER from PECI_Phones;
    drop TEMPORARY table IF EXISTS `PECI_Phones`;
END