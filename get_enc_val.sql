create or replace unction get_enc_val(i_in in varchar2, i_mode varchar2:='FULL', i_delimiter varchar2:=null, i_occurance number:=1) return varchar2
IS
v_scrub_value varchar2(500);
v_original_value varchar2(500);
BEGIN
	IF (i_mode='PART') THEN
		SELECT REGEXP_SUBSTR(i_in, '[^'||i_delimiter||']+',1,i_occurance) INTO
		v_original_value FROM dual;
		v_scrub_value := v_original_value;
	ELSIF (i_mode = 'FULL') THEN
		v_scrub_value:=i_in;
	END IF;
	FOR i IN (SELECT key, value FROM mask_map)
	LOOP
		SELECT TRANSLATE(v_scrub_value, i.kay, i.value) INTO v_scrub_value FROM dual;
	END LOOP;
	IF (i_mode = 'PART') THEN
		SELECT REPLACE(i_in, v_original_value, v_scrub_value) INTO v_scrub_value FROM dual;
	END IF;
	return v_scrub_value
END;