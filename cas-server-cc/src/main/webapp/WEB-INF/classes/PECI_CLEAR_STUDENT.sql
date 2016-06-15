CREATE DEFINER=`root`@`localhost` PROCEDURE `PECI_Clear_Student`(
_STUDENT_PIDM int
)
BEGIN

delete from cc_adv_peci_parents_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from cc_gen_peci_addr_data_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from cc_gen_peci_email_data_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from cc_gen_peci_emergs_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from cc_gen_peci_phone_data_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from cc_stu_peci_students_t where STUDENT_PIDM = _STUDENT_PIDM;

delete from peci_trans_start where STUDENT_PIDM = _STUDENT_PIDM;

END