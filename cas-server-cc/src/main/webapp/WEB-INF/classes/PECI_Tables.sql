DROP TABLE IF EXISTS `peci_trans_start`;
DROP TABLE IF EXISTS `cc_adv_peci_parents_t`;
DROP TABLE IF EXISTS `cc_gen_peci_addr_data_t`;
DROP TABLE IF EXISTS `cc_gen_peci_email_data_t`;
DROP TABLE IF EXISTS `cc_gen_peci_emergs_t`;
DROP TABLE IF EXISTS `cc_gen_peci_phone_data_t`;
DROP TABLE IF EXISTS `cc_stu_peci_students_t`;

CREATE TABLE `peci_trans_start` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` int(11) NOT NULL,
  `Trans_start` datetime NOT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_adv_peci_parents_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `PARENT_PPID` int(11) NOT NULL,
  `TEMP_PPID` varchar(1) NOT NULL DEFAULT 'N',
  `STUDENT_PIDM` int(11) DEFAULT NULL,
  `PARENT_PIDM` int(11) DEFAULT NULL,
  `PARENT_CAMEL_NUMBER` varchar(9) DEFAULT NULL,
  `PARENT_CAMEL_ID` varchar(30) DEFAULT NULL,
  `PARENT_ORDER` int(11) DEFAULT NULL,
  `PARENT_LEGAL_FIRST_NAME` varchar(60) DEFAULT NULL,
  `PARENT_LEGAL_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `PARENT_LEGAL_LAST_NAME` varchar(60) DEFAULT NULL,
  `PARENT_PREF_FIRST_NAME` varchar(60) DEFAULT NULL,
  `PARENT_PREF_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `PARENT_PREF_LAST_NAME` varchar(60) DEFAULT NULL,
  `PARENT_RELT_CODE` varchar(1) DEFAULT NULL,
  `EMERG_CONTACT_PRIORITY` int(10) DEFAULT NULL,
  `EMERG_NO_CELL_PHONE` varchar(1) DEFAULT NULL,
  `EMERG_PHONE_NUMBER_TYPE` varchar(1) DEFAULT NULL,
  `EMERG_CELL_PHONE_CARRIER` varchar(30) DEFAULT NULL,
  `EMERG_PHONE_TTY_DEVICE` varchar(1) DEFAULT NULL,
  `DEPENDENT` varchar(1) DEFAULT NULL,
  `PARENT_GENDER` varchar(1) DEFAULT NULL,
  `PARENT_DECEASED` varchar(1) DEFAULT NULL,
  `PARENT_DECEASED_DATE` date DEFAULT NULL,
  `PECI_ROLE` varchar(5) DEFAULT NULL,
  `CONTACT_TYPE` varchar(20) DEFAULT NULL,
  `PARENT_CONFID_IND` varchar(1) DEFAULT 'N',
  PRIMARY KEY (`STUDENT_PPID`,`PARENT_PPID`,`TEMP_PPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_gen_peci_addr_data_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` int(11) NOT NULL,
  `PARENT_PPID` int(11) NOT NULL DEFAULT '0',
  `TEMP_PPID` varchar(1) NOT NULL DEFAULT '',
  `PARENT_PIDM` varchar(45) DEFAULT NULL,
  `EMERG_CONTACT_PRIORITY` int(11) DEFAULT NULL,
  `PERSON_ROLE` varchar(20) DEFAULT NULL,
  `PECI_ADDR_CODE` varchar(5) DEFAULT NULL,
  `PECI_ADDR_DESC` varchar(45) DEFAULT NULL,
  `ADDR_CODE` varchar(4) DEFAULT NULL,
  `ADDR_SEQUENCE_NO` int(11) DEFAULT NULL,
  `ADDR_STREET_LINE1` varchar(75) DEFAULT NULL,
  `ADDR_STREET_LINE2` varchar(75) DEFAULT NULL,
  `ADDR_STREET_LINE3` varchar(75) DEFAULT NULL,
  `ADDR_CITY` varchar(50) DEFAULT NULL,
  `ADDR_STAT_CODE` varchar(3) DEFAULT NULL,
  `ADDR_ZIP` varchar(30) DEFAULT NULL,
  `ADDR_NATN_CODE` varchar(5) DEFAULT NULL,
  `ADDR_STATUS_IND` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`,`PARENT_PPID`,`TEMP_PPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_gen_peci_email_data_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` int(11) NOT NULL,
  `PARENT_PPID` int(11) NOT NULL DEFAULT '0',
  `TEMP_PPID` varchar(1) NOT NULL DEFAULT '',
  `PARENT_PIDM` int(11) DEFAULT '0',
  `PECI_EMAIL_CODE` varchar(5) DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`,`PARENT_PPID`,`TEMP_PPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_gen_peci_emergs_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` varchar(9) NOT NULL,
  `PARENT_PPID` int(11) NOT NULL DEFAULT '0',
  `TEMP_PPID` varchar(1) NOT NULL DEFAULT '',
  `PARENT PIDM` varchar(45) DEFAULT '',
  `EMERG_LEGAL_FIRST_NAME` varchar(60) DEFAULT NULL,
  `EMERG_LEGAL_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `EMERG_LEGAL_LAST_NAME` varchar(60) DEFAULT NULL,
  `EMERG_PREF_FIRST_NAME` varchar(60) DEFAULT NULL,
  `EMERG_PREF_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `EMERG_PREF_LAST_NAME` varchar(60) DEFAULT NULL,
  `EMERG_RELT_CODE` varchar(1) DEFAULT NULL,
  `EMERG_CONTACT_PRIORITY` int(11) DEFAULT NULL,
  `EMERG_NO_CELL_PHONE` varchar(1) DEFAULT NULL,
  `EMERG_PHONE_NUMBER_TYPE` varchar(1) DEFAULT NULL,
  `EMERG_CELL_PHONE_CARRIER` varchar(30) DEFAULT NULL,
  `EMERG_PHONE_TTY_DEVICE` varchar(1) DEFAULT NULL,
  `DEPENDENT` varchar(1) DEFAULT NULL,
  `PARENT_GENDER` varchar(1) DEFAULT NULL,
  `PARENT_DECEASED` varchar(1) DEFAULT NULL,
  `PARENT_DECEASED_DATE` date DEFAULT NULL,
  `PARENT_CONFID_IND` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`,`PARENT_PPID`,`TEMP_PPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_gen_peci_phone_data_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` int(11) NOT NULL,
  `PARENT_PPID` int(11) NOT NULL DEFAULT '0',
  `TEMP_PPID` varchar(1) NOT NULL DEFAULT '',
  `PARENT_PIDM` int(11) DEFAULT '0',
  `PECI_PHONE_CODE` varchar(5) DEFAULT NULL,
  `PHONE_CODE` varchar(4) DEFAULT NULL,
  `PHONE_AREA_CODE` varchar(128) DEFAULT NULL,
  `PHONE_NUMBER` varchar(45) DEFAULT NULL,
  `PHONE_NUMBER_INTL` varchar(45) DEFAULT NULL,
  `PHONE_SEQUENCE_NO` int(11) DEFAULT NULL,
  `PHONE_STATUS_IND` varchar(1) DEFAULT NULL,
  `PHONE_PRIMARY_IND` varchar(1) DEFAULT NULL,
  `CELL_PHONE_CARRIER` varchar(30) DEFAULT NULL,
  `PHONE_TTY_DEVICE` varchar(1) DEFAULT NULL,
  `EMERG_AUTO_OPT_OUT` varchar(1) DEFAULT NULL,
  `EMERG_SEND_TEXT` varchar(1) DEFAULT NULL,
  `EMERG_NO_CELL_PHONE` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`,`PARENT_PPID`,`TEMP_PPID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cc_stu_peci_students_t` (
  `STUDENT_PPID` int(11) NOT NULL,
  `STUDENT_PIDM` int(11) NOT NULL,
  `CAMEL_NUMBER` varchar(9) DEFAULT NULL,
  `CAMEL_ID` varchar(30) DEFAULT NULL,
  `CLASS_OF` varchar(30) DEFAULT NULL,
  `LEGAL_FIRST_NAME` varchar(60) DEFAULT NULL,
  `LEGAL_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `LEGAL_LAST_NAME` varchar(60) DEFAULT NULL,
  `PREFERRED_FIRST_NAME` varchar(60) DEFAULT NULL,
  `PREFERRED_MIDDLE_NAME` varchar(60) DEFAULT NULL,
  `PREFERRED_LAST_NAME` varchar(60) DEFAULT NULL,
  `LEGAL_DISCLAIMER_DATE` date DEFAULT NULL,
  `DEAN_EXCEPTION_DATE` date DEFAULT NULL,
  `EMERG_PHONE_NUMBER_TYPE_CODE` varchar(4) DEFAULT NULL,
  `EMERG_PHONE_TTY_DEVICE` varchar(1) DEFAULT NULL,
  `EMERG_NO_CELL_PHONE` varchar(1) DEFAULT NULL,
  `EMERG_CELL_PHONE_CARRIER` varchar(30) DEFAULT NULL,
  `EMERG_AUTO_OPT_OUT` varchar(1) DEFAULT NULL,
  `EMERG_SEND_TEXT` varchar(1) DEFAULT NULL,
  `GENDER` varchar(1) DEFAULT NULL,
  `DECEASED` varchar(1) DEFAULT NULL,
  `DECEASED_DATE` date DEFAULT NULL,
  `CONFIDENTIALITY_IND` varchar(1) DEFAULT NULL,
  `STUDENT_STATUS_CODE` varchar(1) DEFAULT NULL,
  `ON_SATA` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`STUDENT_PPID`,`STUDENT_PIDM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
