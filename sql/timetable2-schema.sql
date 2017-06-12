--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.7
-- Dumped by pg_dump version 9.5.7

-- Started on 2017-06-12 23:39:20 GMT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 14 (class 2615 OID 291765)
-- Name: timetable2; Type: SCHEMA; Schema: -; Owner: spadmin
--

CREATE SCHEMA timetable2;


ALTER SCHEMA timetable2 OWNER TO spadmin;

SET search_path = timetable2, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 860 (class 1259 OID 292005)
-- Name: tb_xml_class; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_class (
    recid bigint NOT NULL,
    offeringid bigint,
    configid bigint,
    subpartid bigint,
    parentid bigint,
    schedulerid bigint,
    departmentid bigint,
    committedsol integer,
    classlimit integer,
    minclasslimit integer,
    maxclasslimit integer,
    roomtolimitratio integer,
    nrrooms integer,
    dates character varying,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_class OWNER TO spadmin;

--
-- TOC entry 884 (class 1259 OID 292365)
-- Name: vw_xml_class; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_class AS
 SELECT cl.recid AS rid,
    cl.offeringid AS ofi,
    cl.configid AS cfi,
    cl.subpartid AS sub,
    cl.parentid AS pai,
    cl.schedulerid AS sci,
    cl.departmentid AS dpi,
    cl.committedsol AS cmt,
    cl.classlimit AS cll,
    cl.minclasslimit AS mnl,
    cl.maxclasslimit AS mxl,
    cl.roomtolimitratio AS rlr,
    cl.nrrooms AS nrm,
    cl.dates AS dte,
    cl.datecreated AS dcd,
    cl.status AS sts,
    cl.stamp AS stp
   FROM tb_xml_class cl;


ALTER TABLE vw_xml_class OWNER TO spadmin;

--
-- TOC entry 1811 (class 1255 OID 292369)
-- Name: sp_class_find(bigint, bigint, bigint, bigint, bigint, bigint, bigint, integer, integer, integer, integer, integer, integer, character varying, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_class_find(p_recid bigint, p_offeringid bigint, p_configid bigint, p_subpartid bigint, p_parentid bigint, p_schedulerid bigint, p_departmentid bigint, p_committedsol integer, p_classlimit integer, p_minclasslimit integer, p_maxclasslimit integer, p_roomtolimitratio integer, p_nrrooms integer, p_dates character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_class
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	

    v_cur   CURSOR(v_recid int8, 
		v_offeringid int8, 
		v_configid int8,
		v_subpartid int8,
		v_parentid int8,
		v_schedulerid int8,
		v_departmentid int8,
		v_committedsol int4,
		v_classlimit int4,
		v_minclasslimit int4,
		v_maxclasslimit int4,
		v_roomtolimitratio int4,
		v_nrrooms int4,
		v_dates varchar,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)

    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_class WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("ofi"::VARCHAR,'')= COALESCE(v_offeringid::VARCHAR,COALESCE("ofi"::VARCHAR,'') )
	AND COALESCE("cfi"::VARCHAR,'')= COALESCE(v_configid::VARCHAR,COALESCE("cfi"::VARCHAR,'') )
	AND COALESCE("sub"::VARCHAR,'')= COALESCE(v_subpartid::VARCHAR,COALESCE("sub"::VARCHAR,'') )
	AND COALESCE("pai"::VARCHAR,'')= COALESCE(v_parentid::VARCHAR,COALESCE("pai"::VARCHAR,'') )
	AND COALESCE("sci"::VARCHAR,'')= COALESCE(v_schedulerid::VARCHAR,COALESCE("sci"::VARCHAR,'') )
	AND COALESCE("dpi"::VARCHAR,'')= COALESCE(v_departmentid::VARCHAR,COALESCE("dpi"::VARCHAR,'') )
	AND COALESCE("cmt"::VARCHAR,'')= COALESCE(v_committedsol::VARCHAR,COALESCE("cmt"::VARCHAR,'') )
	AND COALESCE("cll"::VARCHAR,'')= COALESCE(v_classlimit::VARCHAR,COALESCE("cll"::VARCHAR,'') )
	AND COALESCE("mnl"::VARCHAR,'')= COALESCE(v_minclasslimit::VARCHAR,COALESCE("mnl"::VARCHAR,'') )
	AND COALESCE("mxl"::VARCHAR,'')= COALESCE(v_maxclasslimit::VARCHAR,COALESCE("mxl"::VARCHAR,'') )
	AND COALESCE("rlr"::VARCHAR,'')= COALESCE(v_roomtolimitratio::VARCHAR,COALESCE("rlr"::VARCHAR,'') )
	AND COALESCE("nrm"::VARCHAR,'')= COALESCE(v_nrrooms::VARCHAR,COALESCE("nrm"::VARCHAR,'') )
	AND COALESCE("dte"::VARCHAR,'') ILIKE '%'||COALESCE(v_dates::VARCHAR,COALESCE("dte"::VARCHAR,'') )||'%'
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_class%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_offeringid,p_configid,p_subpartid,p_parentid,p_schedulerid,
	p_departmentid,p_committedsol,p_classlimit,p_minclasslimit,p_maxclasslimit,p_roomtolimitratio,
	p_nrrooms,p_dates,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_class_find(p_recid bigint, p_offeringid bigint, p_configid bigint, p_subpartid bigint, p_parentid bigint, p_schedulerid bigint, p_departmentid bigint, p_committedsol integer, p_classlimit integer, p_minclasslimit integer, p_maxclasslimit integer, p_roomtolimitratio integer, p_nrrooms integer, p_dates character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 862 (class 1259 OID 292099)
-- Name: tb_xml_classinstructor; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_classinstructor (
    recid bigint NOT NULL,
    classid bigint,
    instructorid bigint,
    solution integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_classinstructor OWNER TO spadmin;

--
-- TOC entry 885 (class 1259 OID 292370)
-- Name: vw_xml_classinstructor; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_classinstructor AS
 SELECT ci.recid AS rid,
    ci.classid AS cli,
    ci.instructorid AS ini,
    ci.solution AS sol,
    ci.datecreated AS dcd,
    ci.status AS sts,
    ci.stamp AS stp
   FROM tb_xml_classinstructor ci;


ALTER TABLE vw_xml_classinstructor OWNER TO spadmin;

--
-- TOC entry 1813 (class 1255 OID 292374)
-- Name: sp_classinstructor_find(bigint, bigint, bigint, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_classinstructor_find(p_recid bigint, p_classid bigint, p_instructorid bigint, p_solution integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_classinstructor
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_classid int8, 
		v_instructorid int8,
		v_solution int4,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_classinstructor WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("cli"::VARCHAR,'')= COALESCE(v_classid::VARCHAR,COALESCE("cli"::VARCHAR,'') )
	AND COALESCE("ini"::VARCHAR,'')= COALESCE(v_instructorid::VARCHAR,COALESCE("ini"::VARCHAR,'') )
	AND COALESCE("sol"::VARCHAR,'')= COALESCE(v_solution::VARCHAR,COALESCE("sol"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_classinstructor%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_classid,p_instructorid,p_solution,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_classinstructor_find(p_recid bigint, p_classid bigint, p_instructorid bigint, p_solution integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 864 (class 1259 OID 292131)
-- Name: tb_xml_classroom; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_classroom (
    recid bigint NOT NULL,
    classid bigint,
    roomid bigint,
    preference character varying(10),
    solution integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_classroom OWNER TO spadmin;

--
-- TOC entry 865 (class 1259 OID 292140)
-- Name: vw_xml_classroom; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_classroom AS
 SELECT cr.recid AS rid,
    cr.classid AS cli,
    cr.roomid AS rmi,
    cr.solution AS sol,
    cr.preference AS prf,
    cr.datecreated AS dcd,
    cr.status AS sts,
    cr.stamp AS stp
   FROM tb_xml_classroom cr;


ALTER TABLE vw_xml_classroom OWNER TO spadmin;

--
-- TOC entry 1814 (class 1255 OID 292330)
-- Name: sp_classroom_find(bigint, bigint, bigint, character varying, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_classroom_find(p_recid bigint, p_classid bigint, p_roomid bigint, p_preference character varying, p_solution bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_classroom
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_classid int8,
		v_roomid int8,
		v_preference varchar,
		v_solution int4,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_classroom WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("cli"::VARCHAR,'')= COALESCE(v_classid::VARCHAR,COALESCE("cli"::VARCHAR,'') )
	AND COALESCE("rmi"::VARCHAR,'')= COALESCE(v_roomid::VARCHAR,COALESCE("rmi"::VARCHAR,'') )
	AND COALESCE("prf"::VARCHAR,'') ILIKE '%'||COALESCE(v_preference::VARCHAR,COALESCE("prf"::VARCHAR,'') )||'%'
	AND COALESCE("sol"::VARCHAR,'') = COALESCE(v_solution::VARCHAR ,COALESCE("sol"::VARCHAR,''))
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_classroom%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_classid,p_roomid,p_preference,p_solution,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_classroom_find(p_recid bigint, p_classid bigint, p_roomid bigint, p_preference character varying, p_solution bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 867 (class 1259 OID 292161)
-- Name: tb_xml_classtime; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_classtime (
    recid bigint NOT NULL,
    classid bigint,
    days character varying(10),
    starttime integer,
    length integer,
    preference character varying,
    solution integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_classtime OWNER TO spadmin;

--
-- TOC entry 868 (class 1259 OID 292175)
-- Name: vw_xml_classtime; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_classtime AS
 SELECT ct.recid AS rid,
    ct.classid AS cli,
    ct.days AS day,
    ct.starttime AS stt,
    ct.length AS len,
    ct.preference AS prf,
    ct.solution AS sol,
    ct.datecreated AS dcd,
    ct.status AS sts,
    ct.stamp AS stp
   FROM tb_xml_classtime ct;


ALTER TABLE vw_xml_classtime OWNER TO spadmin;

--
-- TOC entry 1817 (class 1255 OID 292378)
-- Name: sp_classtime_find(bigint, bigint, character varying, integer, integer, character varying, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_classtime_find(p_recid bigint, p_classid bigint, p_days character varying, p_starttime integer, p_length integer, p_preference character varying, p_solution integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_classtime
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_classid int8,
		v_days varchar,
		v_starttime int4,
		v_length int4,
		v_preference varchar,
		v_solution int4,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_classtime WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("cli"::VARCHAR,'')= COALESCE(v_classid::VARCHAR,COALESCE("cli"::VARCHAR,'') )
	AND COALESCE("day"::VARCHAR,'') ILIKE '%'||COALESCE(v_days::VARCHAR,COALESCE("day"::VARCHAR,''))||'%'
	AND COALESCE("stt"::VARCHAR,'')= COALESCE(v_starttime::VARCHAR,COALESCE("stt"::VARCHAR,'') )
	AND COALESCE("len"::VARCHAR,'')= COALESCE(v_length::VARCHAR,COALESCE("len"::VARCHAR,'') )
	AND COALESCE("prf"::VARCHAR,'') ILIKE '%'||COALESCE(v_preference::VARCHAR,COALESCE("prf"::VARCHAR,'') )||'%'
	AND COALESCE("sol"::VARCHAR,'') = COALESCE(v_solution::VARCHAR ,COALESCE("sol"::VARCHAR,''))
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_classtime%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_classid,p_days,p_starttime,p_length,p_preference,p_solution,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_classtime_find(p_recid bigint, p_classid bigint, p_days character varying, p_starttime integer, p_length integer, p_preference character varying, p_solution integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1822 (class 1255 OID 300611)
-- Name: sp_constraintclass_add(bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_constraintclass_add(p_groupconstraintid bigint, p_classid bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_constraintclass(groupconstraintid,
		classid,
		datecreated,
		status, 
		stamp)
VALUES (p_groupconstraintid,
	p_classid,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  group constraint id = ' ||COALESCE(et.gci::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_constraintclass et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Constraint class Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_constraintclass_add(p_groupconstraintid bigint, p_classid bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 892 (class 1259 OID 300598)
-- Name: tb_constraintclass; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_constraintclass (
    recid bigint NOT NULL,
    groupconstraintid bigint,
    classid bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_constraintclass OWNER TO spadmin;

--
-- TOC entry 893 (class 1259 OID 300607)
-- Name: vw_constraintclass; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_constraintclass AS
 SELECT cc.recid AS rid,
    cc.groupconstraintid AS gci,
    cc.classid AS cli,
    cc.datecreated AS dcd,
    cc.status AS sts,
    cc.stamp AS stp
   FROM tb_constraintclass cc;


ALTER TABLE vw_constraintclass OWNER TO spadmin;

--
-- TOC entry 1824 (class 1255 OID 300612)
-- Name: sp_constraintclass_find(bigint, bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_constraintclass_find(p_recid bigint, p_groupconstraintid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_constraintclass
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_groupconstraintid int8, 
		v_classid int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_constraintclass WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("gci"::VARCHAR,'')= COALESCE(v_groupconstraintid::VARCHAR,COALESCE("gci"::VARCHAR,'') )
	AND COALESCE("cli"::VARCHAR,'')= COALESCE(v_classid::VARCHAR,COALESCE("cli"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_constraintclass%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_groupconstraintid,p_classid,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_constraintclass_find(p_recid bigint, p_groupconstraintid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1823 (class 1255 OID 300630)
-- Name: sp_constraintparentclass_add(bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_constraintparentclass_add(p_groupconstraintid bigint, p_parentclassid bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_constraintparentclass(groupconstraintid,
		parentclassid,
		datecreated,
		status, 
		stamp)
VALUES (p_groupconstraintid,
	p_parentclassid,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         		||COALESCE(et.rid::varchar,'')
||' ::  group constraintid id = '      	||COALESCE(et.gci::varchar,'')
||' ::  parent class id = '    		||COALESCE(et.pci::varchar,'')
||' ::  Date created = '    		||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         		||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          		||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_constraintparentclass et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Constraint parent class Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_constraintparentclass_add(p_groupconstraintid bigint, p_parentclassid bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 895 (class 1259 OID 300615)
-- Name: tb_constraintparentclass; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_constraintparentclass (
    recid bigint NOT NULL,
    groupconstraintid bigint,
    parentclassid bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_constraintparentclass OWNER TO spadmin;

--
-- TOC entry 896 (class 1259 OID 300626)
-- Name: vw_constraintparentclass; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_constraintparentclass AS
 SELECT cp.recid AS rid,
    cp.groupconstraintid AS gci,
    cp.parentclassid AS pci,
    cp.datecreated AS dcd,
    cp.status AS sts,
    cp.stamp AS stp
   FROM tb_constraintparentclass cp;


ALTER TABLE vw_constraintparentclass OWNER TO spadmin;

--
-- TOC entry 1825 (class 1255 OID 300631)
-- Name: sp_constraintparentclass_find(bigint, bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_constraintparentclass_find(p_recid bigint, p_groupconstraintid bigint, p_parentclassid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_constraintparentclass
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_groupconstraintid int8, 
		v_parentclassid int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_constraintparentclass WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("gci"::VARCHAR,'')= COALESCE(v_groupconstraintid::VARCHAR,COALESCE("gci"::VARCHAR,'') )
	AND COALESCE("pci"::VARCHAR,'')= COALESCE(v_parentclassid::VARCHAR,COALESCE("pci"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_constraintparentclass%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_groupconstraintid,p_parentclassid,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_constraintparentclass_find(p_recid bigint, p_groupconstraintid bigint, p_parentclassid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 870 (class 1259 OID 292220)
-- Name: tb_xml_groupconstraint; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_groupconstraint (
    recid bigint NOT NULL,
    constraintid bigint,
    constrainttypeid character varying(10),
    preference character varying,
    courselimit integer,
    delta integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_groupconstraint OWNER TO spadmin;

--
-- TOC entry 871 (class 1259 OID 292232)
-- Name: vw_xml_groupconstraint; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_groupconstraint AS
 SELECT gc.recid AS rid,
    gc.constraintid AS cid,
    gc.constrainttypeid AS cti,
    gc.preference AS prf,
    gc.courselimit AS col,
    gc.delta AS del,
    gc.datecreated AS dcd,
    gc.status AS sts,
    gc.stamp AS stp
   FROM tb_xml_groupconstraint gc;


ALTER TABLE vw_xml_groupconstraint OWNER TO spadmin;

--
-- TOC entry 1810 (class 1255 OID 292332)
-- Name: sp_groupconstraint_find(bigint, bigint, bigint, character varying, integer, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_groupconstraint_find(p_recid bigint, p_constraintid bigint, p_constrainttypeid bigint, p_preference character varying, p_courselimit integer, p_delta integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_groupconstraint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_constraintid int8,
		v_constrainttypeid int8,
		v_preference varchar,
		v_courselimit int4,
		v_delta int4,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_groupconstraint WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("cid"::VARCHAR,'')= COALESCE(v_constraintid::VARCHAR,COALESCE("cid"::VARCHAR,'') )
	AND COALESCE("cti"::VARCHAR,'')= COALESCE(v_constrainttypeid::VARCHAR,COALESCE("cti"::VARCHAR,'') )
	AND COALESCE("prf"::VARCHAR,'') ILIKE '%'||COALESCE(v_preference::VARCHAR,COALESCE("prf"::VARCHAR,''))||'%'
	AND COALESCE("col"::VARCHAR,'')= COALESCE(v_courselimit::VARCHAR,COALESCE("col"::VARCHAR,'') )
	AND COALESCE("del"::VARCHAR,'')= COALESCE(v_delta::VARCHAR,COALESCE("del"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_groupconstraint%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_constraintid,p_constrainttypeid,p_preference,p_courselimit,
	p_delta,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_groupconstraint_find(p_recid bigint, p_constraintid bigint, p_constrainttypeid bigint, p_preference character varying, p_courselimit integer, p_delta integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 879 (class 1259 OID 292298)
-- Name: tb_xml_prohibitedclass; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_prohibitedclass (
    recid bigint NOT NULL,
    studentid bigint,
    classid bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_prohibitedclass OWNER TO spadmin;

--
-- TOC entry 890 (class 1259 OID 300419)
-- Name: vw_xml_prohibitedclass; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_prohibitedclass AS
 SELECT sc.recid AS rid,
    sc.studentid AS sid,
    sc.classid AS cli,
    sc.datecreated AS dcd,
    sc.status AS sts,
    sc.stamp AS stp
   FROM tb_xml_prohibitedclass sc;


ALTER TABLE vw_xml_prohibitedclass OWNER TO spadmin;

--
-- TOC entry 1821 (class 1255 OID 300423)
-- Name: sp_prohibitedclass_find(bigint, bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_prohibitedclass_find(p_recid bigint, p_studentid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_prohibitedclass
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_studentid int8, 
		v_classid int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_prohibitedclass WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("sid"::VARCHAR,'') = COALESCE(v_studentid::VARCHAR ,COALESCE("sid"::VARCHAR,''))	
	AND COALESCE("cli"::VARCHAR,'') = COALESCE(v_classid::VARCHAR ,COALESCE("cli"::VARCHAR,''))	
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_prohibitedclass%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_studentid,p_classid,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_prohibitedclass_find(p_recid bigint, p_studentid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 854 (class 1259 OID 291897)
-- Name: tb_xml_room; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_room (
    recid bigint NOT NULL,
    capacity integer,
    xylocation character varying,
    ignoretoofar integer,
    discouraged integer,
    constrained integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_room OWNER TO spadmin;

--
-- TOC entry 855 (class 1259 OID 291909)
-- Name: vw_xml_room; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_room AS
 SELECT rm.recid AS rid,
    rm.capacity AS cap,
    rm.xylocation AS loc,
    rm.ignoretoofar AS itf,
    rm.discouraged AS dis,
    rm.constrained AS con,
    rm.datecreated AS dcd,
    rm.status AS sts,
    rm.stamp AS stp
   FROM tb_xml_room rm;


ALTER TABLE vw_xml_room OWNER TO spadmin;

--
-- TOC entry 1809 (class 1255 OID 292324)
-- Name: sp_room_find(bigint, integer, character varying, integer, integer, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_room_find(p_recid bigint, p_capacity integer, p_xylocation character varying, p_ignoretoofar integer, p_discouraged integer, p_constrained integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_room
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	

    v_cur   CURSOR(v_recid int8, 
		v_capacity int4, 
		v_xylocation varchar,
		v_ignoretoofar int4,
		v_discouraged int4, 	
		v_constrained int4,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)

    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_room WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("cap"::VARCHAR,'')= COALESCE(v_capacity::VARCHAR,COALESCE("cap"::VARCHAR,'') )
	AND COALESCE("loc"::VARCHAR,'') ILIKE '%'||COALESCE(v_xylocation::VARCHAR,COALESCE("loc"::VARCHAR,'') )||'%'
	AND COALESCE("itf"::VARCHAR,'')= COALESCE(v_ignoretoofar::VARCHAR,COALESCE("itf"::VARCHAR,'') )
	AND COALESCE("dis"::VARCHAR,'')= COALESCE(v_discouraged::VARCHAR,COALESCE("dis"::VARCHAR,'') )
	AND COALESCE("con"::VARCHAR,'')= COALESCE(v_constrained::VARCHAR,COALESCE("con"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_room%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_capacity,p_xylocation,p_ignoretoofar,p_discouraged,p_constrained,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_room_find(p_recid bigint, p_capacity integer, p_xylocation character varying, p_ignoretoofar integer, p_discouraged integer, p_constrained integer, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 881 (class 1259 OID 292340)
-- Name: tb_sharingmatrix; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_sharingmatrix (
    recid bigint NOT NULL,
    roomid bigint,
    patternid bigint,
    deptid bigint,
    deptvalue bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_sharingmatrix OWNER TO spadmin;

--
-- TOC entry 882 (class 1259 OID 292349)
-- Name: vw_xml_sharingmatrix; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_sharingmatrix AS
 SELECT sm.recid AS rid,
    sm.roomid AS rmi,
    sm.patternid AS pti,
    sm.deptid AS dpi,
    sm.deptvalue AS dpv,
    sm.datecreated AS dcd,
    sm.status AS sts,
    sm.stamp AS stp
   FROM tb_sharingmatrix sm;


ALTER TABLE vw_xml_sharingmatrix OWNER TO spadmin;

--
-- TOC entry 1818 (class 1255 OID 292465)
-- Name: sp_sharingmatrix_find(bigint, bigint, bigint, bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_sharingmatrix_find(p_recid bigint, p_roomid bigint, p_patternid bigint, p_deptid bigint, p_deptvalue bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_sharingmatrix
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_roomid int8, 
		v_patternid int8,
		v_deptid int8,
		v_deptvalue int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_sharingmatrix WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("rmi"::VARCHAR,'') = COALESCE(v_roomid::VARCHAR ,COALESCE("rmi"::VARCHAR,''))	
	AND COALESCE("pti"::VARCHAR,'') = COALESCE(v_patternid::VARCHAR ,COALESCE("pti"::VARCHAR,''))	
	AND COALESCE("dpi"::VARCHAR,'') = COALESCE(v_deptid::VARCHAR ,COALESCE("dpi"::VARCHAR,''))	
	AND COALESCE("dpv"::VARCHAR,'') = COALESCE(v_deptvalue::VARCHAR ,COALESCE("dpv"::VARCHAR,''))	
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_sharingmatrix%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_roomid,p_patternid,p_deptid,p_deptvalue,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_sharingmatrix_find(p_recid bigint, p_roomid bigint, p_patternid bigint, p_deptid bigint, p_deptvalue bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 857 (class 1259 OID 291933)
-- Name: tb_sharingpattern; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_sharingpattern (
    recid bigint NOT NULL,
    unit integer,
    pattern character varying,
    freeforall character varying(2),
    notavailable character varying(2),
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_sharingpattern OWNER TO spadmin;

--
-- TOC entry 858 (class 1259 OID 291949)
-- Name: vw_xml_sharingpattern; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_sharingpattern AS
 SELECT sp.recid AS rid,
    sp.unit AS unt,
    sp.pattern AS pat,
    sp.freeforall AS ffa,
    sp.notavailable AS nav,
    sp.datecreated AS dcd,
    sp.status AS sts,
    sp.stamp AS stp
   FROM tb_sharingpattern sp;


ALTER TABLE vw_xml_sharingpattern OWNER TO spadmin;

--
-- TOC entry 1816 (class 1255 OID 292356)
-- Name: sp_sharingpattern_find(bigint, integer, character varying, character varying, character varying, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_sharingpattern_find(p_recid bigint, p_unit integer, p_pattern character varying, p_freeforall character varying, p_notavailable character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_sharingpattern
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_unit int4, 
		v_pattern varchar,
		v_freeforall varchar,
		v_notavailable int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_sharingpattern WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("unt"::VARCHAR,'') = COALESCE(v_unit::VARCHAR ,COALESCE("unt"::VARCHAR,''))
	AND COALESCE("pat"::VARCHAR,'') ILIKE '%'||COALESCE(v_pattern::VARCHAR,COALESCE("pat"::VARCHAR,''))||'%'	
	AND COALESCE("ffa"::VARCHAR,'') ILIKE '%'||COALESCE(v_freeforall::VARCHAR,COALESCE("ffa"::VARCHAR,''))||'%'	
	AND COALESCE("nav"::VARCHAR,'') ILIKE '%'||COALESCE(v_notavailable::VARCHAR,COALESCE("nav"::VARCHAR,''))||'%'	
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_sharingpattern%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_unit,p_pattern,p_freeforall,
			p_notavailable,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_sharingpattern_find(p_recid bigint, p_unit integer, p_pattern character varying, p_freeforall character varying, p_notavailable character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 873 (class 1259 OID 292244)
-- Name: tb_xml_student; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_student (
    recid bigint NOT NULL,
    studentid bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_student OWNER TO spadmin;

--
-- TOC entry 883 (class 1259 OID 292357)
-- Name: vw_xml_student; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_student AS
 SELECT st.recid AS rid,
    st.studentid AS sid,
    st.datecreated AS dcd,
    st.status AS sts,
    st.stamp AS stp
   FROM tb_xml_student st;


ALTER TABLE vw_xml_student OWNER TO spadmin;

--
-- TOC entry 1800 (class 1255 OID 292361)
-- Name: sp_student_find(bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_student_find(p_recid bigint, p_studentid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_student
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_studentid int8, 
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_student WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("sid"::VARCHAR,'')= COALESCE(v_studentid::VARCHAR,COALESCE("sid"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_student%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_studentid,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_student_find(p_recid bigint, p_studentid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 875 (class 1259 OID 292266)
-- Name: tb_xml_studentclass; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_studentclass (
    recid bigint NOT NULL,
    studentid bigint,
    classid bigint,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_studentclass OWNER TO spadmin;

--
-- TOC entry 889 (class 1259 OID 300414)
-- Name: vw_xml_studentclass; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_studentclass AS
 SELECT sc.recid AS rid,
    sc.studentid AS sid,
    sc.classid AS cli,
    sc.datecreated AS dcd,
    sc.status AS sts,
    sc.stamp AS stp
   FROM tb_xml_studentclass sc;


ALTER TABLE vw_xml_studentclass OWNER TO spadmin;

--
-- TOC entry 1819 (class 1255 OID 300418)
-- Name: sp_studentclass_find(bigint, bigint, bigint, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_studentclass_find(p_recid bigint, p_studentid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_studentclass
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8, 
		v_studentid int8, 
		v_classid int8,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_studentclass WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("sid"::VARCHAR,'')= COALESCE(v_studentid::VARCHAR,COALESCE("sid"::VARCHAR,'') )
	AND COALESCE("cli"::VARCHAR,'')= COALESCE(v_classid::VARCHAR,COALESCE("cli"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_studentclass%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_studentid,p_classid,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_studentclass_find(p_recid bigint, p_studentid bigint, p_classid bigint, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 877 (class 1259 OID 292283)
-- Name: tb_xml_studentoffering; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_xml_studentoffering (
    recid bigint NOT NULL,
    studentid bigint,
    offeringid bigint,
    weight double precision,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_xml_studentoffering OWNER TO spadmin;

--
-- TOC entry 888 (class 1259 OID 300409)
-- Name: vw_xml_studentoffering; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_xml_studentoffering AS
 SELECT so.recid AS rid,
    so.studentid AS sid,
    so.offeringid AS ofi,
    so.weight AS wgt,
    so.datecreated AS dcd,
    so.status AS sts,
    so.stamp AS stp
   FROM tb_xml_studentoffering so;


ALTER TABLE vw_xml_studentoffering OWNER TO spadmin;

--
-- TOC entry 1820 (class 1255 OID 300413)
-- Name: sp_studentoffering_find(bigint, bigint, bigint, double precision, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_studentoffering_find(p_recid bigint, p_studentid bigint, p_offeringid bigint, p_weight double precision, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_xml_studentoffering
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8,
		v_studentid int8, 
		v_offeringid int8,
		v_weight double precision,
		v_status int4,
		v_pageoffset int4, 
		v_pagelimit int4)
    FOR SELECT *, count(*) over () AS total FROM timetable2.vw_xml_studentoffering WHERE
	   COALESCE("rid"::VARCHAR,'')= COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("sid"::VARCHAR,'')= COALESCE(v_studentid::VARCHAR,COALESCE("sid"::VARCHAR,'') )
	AND COALESCE("ofi"::VARCHAR,'')= COALESCE(v_offeringid::VARCHAR,COALESCE("ofi"::VARCHAR,'') )
	AND COALESCE("wgt"::VARCHAR,'')= COALESCE(v_weight::VARCHAR,COALESCE("wgt"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR ,COALESCE("sts"::VARCHAR,''))
    LIMIT COALESCE(v_pagelimit,9223372036854775807) OFFSET COALESCE(v_pageoffset,0);
    v_rec  timetable2.vw_xml_studentoffering%ROWTYPE;
   v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;

	FOR vci IN v_cur(p_recid,p_studentid,p_offeringid,p_weight,p_status,p_pageoffset,p_pagelimit) LOOP 
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_studentoffering_find(p_recid bigint, p_studentid bigint, p_offeringid bigint, p_weight double precision, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 886 (class 1259 OID 292449)
-- Name: tb_timetabledefault; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_timetabledefault (
    recid bigint NOT NULL,
    rectype character(1) DEFAULT 'G'::bpchar NOT NULL,
    reckey character varying(50) NOT NULL,
    recvalue character varying(4000) NOT NULL,
    description text,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_timetabledefault OWNER TO spadmin;

--
-- TOC entry 887 (class 1259 OID 292460)
-- Name: vw_timetabledefault; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_timetabledefault AS
 SELECT td.recid AS rid,
    td.rectype AS typ,
    td.reckey AS nam,
    td.recvalue AS val,
    td.description AS dsc,
    td.status AS sts,
    td.stamp AS stp
   FROM tb_timetabledefault td;


ALTER TABLE vw_timetabledefault OWNER TO spadmin;

--
-- TOC entry 1815 (class 1255 OID 292464)
-- Name: sp_timetabledefault_find(bigint, character varying, character varying, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_timetabledefault_find(p_recid bigint, p_reckey character varying, p_recvalue character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) RETURNS SETOF vw_timetabledefault
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE	
    v_cur   CURSOR(v_recid int8,
		   v_reckey varchar,
		   v_recvalue varchar,
		   v_status int4,
		   v_pageoffset int4, 
		   v_pagelimit int4)
	FOR SELECT *, count(*) over () AS total FROM timetable2.vw_timetabledefault WHERE
	    COALESCE("rid"::VARCHAR,'') = COALESCE(v_recid::VARCHAR,COALESCE("rid"::VARCHAR,'') )
	AND COALESCE("typ"::VARCHAR,'') = COALESCE(v_reckey::VARCHAR,COALESCE("typ"::VARCHAR,'') )
	AND COALESCE("nam"::VARCHAR,'') = COALESCE(v_recvalue::VARCHAR,COALESCE("nam"::VARCHAR,'') )
	AND COALESCE("sts"::VARCHAR,'') = COALESCE(v_status::VARCHAR,COALESCE("sts"::VARCHAR,'') )
	--AND UPPER(TRIM("type"))='G'
	LIMIT COALESCE(v_pagelimit,9223372036854775807)  OFFSET COALESCE(v_pageoffset,0);

	v_rec  timetable2.vw_timetabledefault%ROWTYPE;
	v_res  bigint;
BEGIN 
	--COUNT OF VALID RECORDS
	v_res := 0;
	FOR vci IN v_cur(p_recid,p_reckey,p_recvalue,p_status,p_pageoffset,p_pagelimit) LOOP 	
	    IF (v_res = 0) THEN
	        v_rec.rid = vci.total;
	        RETURN NEXT v_rec;
	        v_res := 1;
	    END IF;
	    v_rec := vci;
	    RETURN NEXT v_rec;
	END LOOP;
END;
$$;


ALTER FUNCTION timetable2.sp_timetabledefault_find(p_recid bigint, p_reckey character varying, p_recvalue character varying, p_status integer, p_pageoffset integer, p_pagelimit integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1812 (class 1255 OID 292024)
-- Name: sp_xml_class_add(bigint, bigint, bigint, bigint, bigint, bigint, bigint, integer, integer, integer, integer, integer, integer, character varying, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_class_add(p_recid bigint, p_offeringid bigint, p_configid bigint, p_subpartid bigint, p_parentid bigint, p_schedulerid bigint, p_departmentid bigint, p_committedsol integer, p_classlimit integer, p_minclasslimit integer, p_maxclasslimit integer, p_roomtolimitratio integer, p_nrrooms integer, p_dates character varying, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_class(recid,
		offeringid,
		configid,
		subpartid,
		parentid,
		schedulerid,
		departmentid,
		committedsol,
		classlimit,
		minclasslimit,
		maxclasslimit,
		roomtolimitratio,
		nrrooms,
		dates,
		datecreated,
		status, 
		stamp)
VALUES (p_recid,
	p_offeringid,
	p_configid,
	p_subpartid,
	p_parentid,
	p_schedulerid,
	p_departmentid,
	p_committedsol,
	p_classlimit,
	p_minclasslimit,
	p_maxclasslimit,
	p_roomtolimitratio,
	p_nrrooms,
	p_dates,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  offering id = '      	||COALESCE(et.ofi::varchar,'')
||' ::  config id = '     	||COALESCE(et.cfi::varchar,'')
||' ::  subpart id = '     	||COALESCE(et.sub::varchar,'')
||' ::  parentid = '    	||COALESCE(et.pai::varchar,'')
||' ::  schedulerid = '    	||COALESCE(et.sci::varchar,'')
||' ::  departmentid = '     	||COALESCE(et.dpi::varchar,'')
||' ::  committed solution = '  ||COALESCE(et.cmt::varchar,'')
||' ::  classlimit = '    	||COALESCE(et.cll::varchar,'')
||' ::  minclasslimit = '    	||COALESCE(et.mnl::varchar,'')
||' ::  maxclasslimit = '    	||COALESCE(et.mxl::varchar,'')
||' ::  roomtolimitratio = '    ||COALESCE(et.rlr::varchar,'')
||' ::  nrrooms = '    		||COALESCE(et.nrm::varchar,'')
||' ::  dates = '    		||COALESCE(et.dte::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_class et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML C Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_class_add(p_recid bigint, p_offeringid bigint, p_configid bigint, p_subpartid bigint, p_parentid bigint, p_schedulerid bigint, p_departmentid bigint, p_committedsol integer, p_classlimit integer, p_minclasslimit integer, p_maxclasslimit integer, p_roomtolimitratio integer, p_nrrooms integer, p_dates character varying, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1793 (class 1255 OID 292112)
-- Name: sp_xml_classinstructor_add(bigint, bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_classinstructor_add(p_classid bigint, p_instructorid bigint, p_solution bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_classinstructor(classid,
		instructorid,
		solution,
		datecreated,
		status, 
		stamp)
VALUES (p_classid,
	p_instructorid,
	p_solution,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  instructor id = '      	||COALESCE(et.ini::varchar,'')
||' ::  solution = '     	||COALESCE(et.sol::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_classinstructor et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Class instructor Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_classinstructor_add(p_classid bigint, p_instructorid bigint, p_solution bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1795 (class 1255 OID 292144)
-- Name: sp_xml_classroom_add(bigint, bigint, character varying, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_classroom_add(p_classid bigint, p_roomid bigint, p_preference character varying, p_solution bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_classroom(classid,
		roomid,
		preference,
		solution,
		datecreated,
		status, 
		stamp)
VALUES (p_classid,
	p_roomid,
	p_preference,
	p_solution,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  room id = '      	||COALESCE(et.rmi::varchar,'')
||' ::  preference = '      	||COALESCE(et.prf::varchar,'')
||' ::  solution id = '     	||COALESCE(et.sol::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_classroom et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Classroom Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_classroom_add(p_classid bigint, p_roomid bigint, p_preference character varying, p_solution bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1804 (class 1255 OID 292179)
-- Name: sp_xml_classtime_add(bigint, character varying, integer, integer, character varying, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_classtime_add(p_classid bigint, p_days character varying, p_starttime integer, p_length integer, p_preference character varying, p_solution bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_classtime(classid,
		days,
		starttime,
		length,
		preference,
		solution,
		datecreated,
		status, 
		stamp)
VALUES (p_classid,
	p_days,
	p_starttime,
	p_length,	
	p_preference,
	p_solution,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  days = '      		||COALESCE(et.day::varchar,'')
||' ::  start time = '      	||COALESCE(et.stt::varchar,'')
||' ::  length = '     		||COALESCE(et.len::varchar,'')
||' ::  preference = '      	||COALESCE(et.prf::varchar,'')
||' ::  solution id = '     	||COALESCE(et.sol::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_classtime et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Classtime Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_classtime_add(p_classid bigint, p_days character varying, p_starttime integer, p_length integer, p_preference character varying, p_solution bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1803 (class 1255 OID 292237)
-- Name: sp_xml_groupconstraint_add(bigint, bigint, character varying, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_groupconstraint_add(p_constraintid bigint, p_constrainttypeid bigint, p_preference character varying, p_courselimit integer, p_delta integer, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_groupconstraint(constraintid,
		constrainttypeid,
		preference,
		courselimit,
		delta,
		datecreated,
		status, 
		stamp)
VALUES (p_constraintid,
	p_constrainttypeid,
	TRIM(p_preference),
	p_courselimit,
	p_delta,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  constraint id = '      	||COALESCE(et.cid::varchar,'')
||' ::  constraint type id = '  ||COALESCE(et.cti::varchar,'')
||' ::  preference = '      	||COALESCE(et.prf::varchar,'')
||' ::  course limit = '     	||COALESCE(et.col::varchar,'')
||' ::  delta = '     		||COALESCE(et.del::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '      		||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_groupconstraint et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Group constraint Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_groupconstraint_add(p_constraintid bigint, p_constrainttypeid bigint, p_preference character varying, p_courselimit integer, p_delta integer, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1806 (class 1255 OID 292313)
-- Name: sp_xml_prohibitedclass_add(bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_prohibitedclass_add(p_studentid bigint, p_classid bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_prohibitedclass(studentid,
		classid,
		datecreated,
		status, 
		stamp)
VALUES (p_studentid,
	p_classid,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  student id = '      	||COALESCE(et.sid::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_prohibitedclass et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML prohibited class Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_prohibitedclass_add(p_studentid bigint, p_classid bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1801 (class 1255 OID 291914)
-- Name: sp_xml_room_add(bigint, integer, character varying, integer, integer, integer, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_room_add(p_recid bigint, p_capacity integer, p_xylocation character varying, p_ignoretoofar integer, p_discouraged integer, p_constrained integer, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_room(recid,
		capacity,
  		xylocation,
  		ignoretoofar,
  		discouraged,
  		constrained,
  		datecreated,
		status, 
		stamp)
VALUES (p_recid,
	p_capacity,
	p_xylocation,
	p_ignoretoofar,
	p_discouraged,
	p_constrained,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  Capacity = '      	||COALESCE(et.cap::varchar,'')
||' ::  Location = '     	||COALESCE(et.loc::varchar,'')
||' ::  Ignore Too Far = '     	||COALESCE(et.itf::varchar,'')
||' ::  Discouraged = '    	||COALESCE(et.dis::varchar,'')
||' ::  Constrained = '    	||COALESCE(et.con::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_room et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Room Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_room_add(p_recid bigint, p_capacity integer, p_xylocation character varying, p_ignoretoofar integer, p_discouraged integer, p_constrained integer, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1796 (class 1255 OID 292354)
-- Name: sp_xml_sharingmatrix_add(bigint, bigint, bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_sharingmatrix_add(p_roomid bigint, p_patternid bigint, p_deptid bigint, p_deptvalue bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_sharingmatrix(roomid,
  		patternid,
  		deptid,
  		deptvalue,
  		datecreated,
		status, 
		stamp)
VALUES (p_roomid,
	p_patternid,
	p_deptid,
	p_deptvalue,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  roomid = '      	||COALESCE(et.rmi::varchar,'')
||' ::  pattern id = '      	||COALESCE(et.pti::varchar,'')
||' ::  deptid = '      	||COALESCE(et.dpi::varchar,'')
||' ::  deptvalue = '      	||COALESCE(et.dpv::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_sharingmatrix et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Sharing matrix Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_sharingmatrix_add(p_roomid bigint, p_patternid bigint, p_deptid bigint, p_deptvalue bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1802 (class 1255 OID 291954)
-- Name: sp_xml_sharingpattern_add(integer, character varying, character varying, character varying, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_sharingpattern_add(p_unit integer, p_pattern character varying, p_freeforall character varying, p_notavailable character varying, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_sharingpattern(unit,
  		pattern,
  		freeforall,
  		notavailable,
  		datecreated,
		status, 
		stamp)
VALUES (p_unit,
	p_pattern,
	p_freeforall,
	p_notavailable,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  unit = '      		||COALESCE(et.unt::varchar,'')
||' ::  pattern = '     	||COALESCE(et.pat::varchar,'')
||' ::  freeforall = '     	||COALESCE(et.ffa::varchar,'')
||' ::  notavailable = '     	||COALESCE(et.nav::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_sharingpattern et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Sharing pattern Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_sharingpattern_add(p_unit integer, p_pattern character varying, p_freeforall character varying, p_notavailable character varying, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1797 (class 1255 OID 292263)
-- Name: sp_xml_student_add(bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_student_add(p_studentid bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_student(studentid,
		datecreated,
		status, 
		stamp)
VALUES (p_studentid,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  student id = '      	||COALESCE(et.sid::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_student et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Student Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_student_add(p_studentid bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1807 (class 1255 OID 292279)
-- Name: sp_xml_studentclass_add(bigint, bigint, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_studentclass_add(p_studentid bigint, p_classid bigint, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_studentclass(studentid,
		classid,
		datecreated,
		status, 
		stamp)
VALUES (p_studentid,
	p_classid,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  student id = '      	||COALESCE(et.sid::varchar,'')
||' ::  class id = '      	||COALESCE(et.cli::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_studentclass et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Student class Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_studentclass_add(p_studentid bigint, p_classid bigint, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 1805 (class 1255 OID 292280)
-- Name: sp_xml_studentoffering_add(bigint, bigint, double precision, integer, bigint); Type: FUNCTION; Schema: timetable2; Owner: spadmin
--

CREATE FUNCTION sp_xml_studentoffering_add(p_studentid bigint, p_offeringid bigint, p_weight double precision, p_status integer, p_userid bigint) RETURNS SETOF security.vws_add
    LANGUAGE plpgsql
    AS $$
DECLARE	
	v_rec vws_add%ROWTYPE;
	v_audit text;
BEGIN
/**Insert Data Into Table**/
INSERT INTO timetable2.tb_xml_studentoffering(studentid,
		offeringid,
		weight,
		datecreated,
		status, 
		stamp)
VALUES (p_studentid,
	p_offeringid,
	p_weight,
	now(),
	p_status, 
	now())
RETURNING recid,stamp INTO  v_rec.rid, v_rec.stp;


/**Prepare Data for Audit **/
SELECT 'RecId = '         	||COALESCE(et.rid::varchar,'')
||' ::  student id = '      	||COALESCE(et.sid::varchar,'')
||' ::  offering id = '      	||COALESCE(et.ofi::varchar,'')
||' ::  weight = '      	||COALESCE(et.wgt::varchar,'')
||' ::  Date created = '    	||COALESCE(et.dcd::varchar,'')
||' ::  Status = '         	||COALESCE(et.sts::varchar,'')
||' ::  Stamp = '          	||COALESCE(et.stp::varchar,'')

INTO v_audit FROM timetable2.vw_xml_studentoffering et WHERE et.rid=v_rec.rid;
	
	/**Record Audit**/
	PERFORM fns_audittrail_add(p_userid,'XML Student offering Add',v_audit);

	/**Return Data**/
	RETURN NEXT v_rec;
END;
$$;


ALTER FUNCTION timetable2.sp_xml_studentoffering_add(p_studentid bigint, p_offeringid bigint, p_weight double precision, p_status integer, p_userid bigint) OWNER TO spadmin;

--
-- TOC entry 891 (class 1259 OID 300596)
-- Name: tb_constraintclass_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_constraintclass_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_constraintclass_recid_seq OWNER TO spadmin;

--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 891
-- Name: tb_constraintclass_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_constraintclass_recid_seq OWNED BY tb_constraintclass.recid;


--
-- TOC entry 894 (class 1259 OID 300613)
-- Name: tb_constraintparentclass_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_constraintparentclass_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_constraintparentclass_recid_seq OWNER TO spadmin;

--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 894
-- Name: tb_constraintparentclass_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_constraintparentclass_recid_seq OWNED BY tb_constraintparentclass.recid;


--
-- TOC entry 851 (class 1259 OID 291879)
-- Name: tb_room; Type: TABLE; Schema: timetable2; Owner: spadmin
--

CREATE TABLE tb_room (
    recid bigint NOT NULL,
    recname character varying,
    shortcode character varying,
    capacity integer,
    buildingid bigint,
    xylocation character varying,
    ignoretoofar integer,
    discouraged integer,
    constrained integer,
    datecreated timestamp without time zone DEFAULT now() NOT NULL,
    status integer DEFAULT 1 NOT NULL,
    stamp timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE tb_room OWNER TO spadmin;

--
-- TOC entry 850 (class 1259 OID 291877)
-- Name: tb_room_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_room_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_room_recid_seq OWNER TO spadmin;

--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 850
-- Name: tb_room_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_room_recid_seq OWNED BY tb_room.recid;


--
-- TOC entry 880 (class 1259 OID 292338)
-- Name: tb_sharingmatrix_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_sharingmatrix_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_sharingmatrix_recid_seq OWNER TO spadmin;

--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 880
-- Name: tb_sharingmatrix_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_sharingmatrix_recid_seq OWNED BY tb_sharingmatrix.recid;


--
-- TOC entry 856 (class 1259 OID 291931)
-- Name: tb_sharingpattern_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_sharingpattern_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_sharingpattern_recid_seq OWNER TO spadmin;

--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 856
-- Name: tb_sharingpattern_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_sharingpattern_recid_seq OWNED BY tb_sharingpattern.recid;


--
-- TOC entry 859 (class 1259 OID 292003)
-- Name: tb_xml_class_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_class_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_class_recid_seq OWNER TO spadmin;

--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 859
-- Name: tb_xml_class_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_class_recid_seq OWNED BY tb_xml_class.recid;


--
-- TOC entry 861 (class 1259 OID 292097)
-- Name: tb_xml_classinstructor_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_classinstructor_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_classinstructor_recid_seq OWNER TO spadmin;

--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 861
-- Name: tb_xml_classinstructor_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_classinstructor_recid_seq OWNED BY tb_xml_classinstructor.recid;


--
-- TOC entry 863 (class 1259 OID 292129)
-- Name: tb_xml_classroom_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_classroom_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_classroom_recid_seq OWNER TO spadmin;

--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 863
-- Name: tb_xml_classroom_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_classroom_recid_seq OWNED BY tb_xml_classroom.recid;


--
-- TOC entry 866 (class 1259 OID 292159)
-- Name: tb_xml_classtime_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_classtime_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_classtime_recid_seq OWNER TO spadmin;

--
-- TOC entry 5488 (class 0 OID 0)
-- Dependencies: 866
-- Name: tb_xml_classtime_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_classtime_recid_seq OWNED BY tb_xml_classtime.recid;


--
-- TOC entry 869 (class 1259 OID 292218)
-- Name: tb_xml_groupconstraint_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_groupconstraint_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_groupconstraint_recid_seq OWNER TO spadmin;

--
-- TOC entry 5489 (class 0 OID 0)
-- Dependencies: 869
-- Name: tb_xml_groupconstraint_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_groupconstraint_recid_seq OWNED BY tb_xml_groupconstraint.recid;


--
-- TOC entry 878 (class 1259 OID 292296)
-- Name: tb_xml_prohibitedclass_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_prohibitedclass_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_prohibitedclass_recid_seq OWNER TO spadmin;

--
-- TOC entry 5490 (class 0 OID 0)
-- Dependencies: 878
-- Name: tb_xml_prohibitedclass_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_prohibitedclass_recid_seq OWNED BY tb_xml_prohibitedclass.recid;


--
-- TOC entry 853 (class 1259 OID 291895)
-- Name: tb_xml_room_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_room_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_room_recid_seq OWNER TO spadmin;

--
-- TOC entry 5491 (class 0 OID 0)
-- Dependencies: 853
-- Name: tb_xml_room_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_room_recid_seq OWNED BY tb_xml_room.recid;


--
-- TOC entry 872 (class 1259 OID 292242)
-- Name: tb_xml_student_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_student_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_student_recid_seq OWNER TO spadmin;

--
-- TOC entry 5492 (class 0 OID 0)
-- Dependencies: 872
-- Name: tb_xml_student_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_student_recid_seq OWNED BY tb_xml_student.recid;


--
-- TOC entry 874 (class 1259 OID 292264)
-- Name: tb_xml_studentclass_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_studentclass_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_studentclass_recid_seq OWNER TO spadmin;

--
-- TOC entry 5493 (class 0 OID 0)
-- Dependencies: 874
-- Name: tb_xml_studentclass_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_studentclass_recid_seq OWNED BY tb_xml_studentclass.recid;


--
-- TOC entry 876 (class 1259 OID 292281)
-- Name: tb_xml_studentoffering_recid_seq; Type: SEQUENCE; Schema: timetable2; Owner: spadmin
--

CREATE SEQUENCE tb_xml_studentoffering_recid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tb_xml_studentoffering_recid_seq OWNER TO spadmin;

--
-- TOC entry 5494 (class 0 OID 0)
-- Dependencies: 876
-- Name: tb_xml_studentoffering_recid_seq; Type: SEQUENCE OWNED BY; Schema: timetable2; Owner: spadmin
--

ALTER SEQUENCE tb_xml_studentoffering_recid_seq OWNED BY tb_xml_studentoffering.recid;


--
-- TOC entry 852 (class 1259 OID 291891)
-- Name: vw_room; Type: VIEW; Schema: timetable2; Owner: spadmin
--

CREATE VIEW vw_room AS
 SELECT rm.recid AS rid,
    rm.recname AS nam,
    rm.shortcode AS shc,
    rm.capacity AS cap,
    rm.buildingid AS bid,
    rm.xylocation AS loc,
    rm.ignoretoofar AS itf,
    rm.discouraged AS dis,
    rm.constrained AS con,
    rm.datecreated AS dcd,
    rm.status AS sts,
    rm.stamp AS stp
   FROM tb_room rm;


ALTER TABLE vw_room OWNER TO spadmin;

--
-- TOC entry 5071 (class 2604 OID 300601)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_constraintclass ALTER COLUMN recid SET DEFAULT nextval('tb_constraintclass_recid_seq'::regclass);


--
-- TOC entry 5075 (class 2604 OID 300618)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_constraintparentclass ALTER COLUMN recid SET DEFAULT nextval('tb_constraintparentclass_recid_seq'::regclass);


--
-- TOC entry 5016 (class 2604 OID 291882)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_room ALTER COLUMN recid SET DEFAULT nextval('tb_room_recid_seq'::regclass);


--
-- TOC entry 5064 (class 2604 OID 292343)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_sharingmatrix ALTER COLUMN recid SET DEFAULT nextval('tb_sharingmatrix_recid_seq'::regclass);


--
-- TOC entry 5024 (class 2604 OID 291936)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_sharingpattern ALTER COLUMN recid SET DEFAULT nextval('tb_sharingpattern_recid_seq'::regclass);


--
-- TOC entry 5028 (class 2604 OID 292008)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_class ALTER COLUMN recid SET DEFAULT nextval('tb_xml_class_recid_seq'::regclass);


--
-- TOC entry 5032 (class 2604 OID 292102)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classinstructor ALTER COLUMN recid SET DEFAULT nextval('tb_xml_classinstructor_recid_seq'::regclass);


--
-- TOC entry 5036 (class 2604 OID 292134)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classroom ALTER COLUMN recid SET DEFAULT nextval('tb_xml_classroom_recid_seq'::regclass);


--
-- TOC entry 5040 (class 2604 OID 292164)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classtime ALTER COLUMN recid SET DEFAULT nextval('tb_xml_classtime_recid_seq'::regclass);


--
-- TOC entry 5044 (class 2604 OID 292223)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_groupconstraint ALTER COLUMN recid SET DEFAULT nextval('tb_xml_groupconstraint_recid_seq'::regclass);


--
-- TOC entry 5060 (class 2604 OID 292301)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_prohibitedclass ALTER COLUMN recid SET DEFAULT nextval('tb_xml_prohibitedclass_recid_seq'::regclass);


--
-- TOC entry 5020 (class 2604 OID 291900)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_room ALTER COLUMN recid SET DEFAULT nextval('tb_xml_room_recid_seq'::regclass);


--
-- TOC entry 5048 (class 2604 OID 292247)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_student ALTER COLUMN recid SET DEFAULT nextval('tb_xml_student_recid_seq'::regclass);


--
-- TOC entry 5052 (class 2604 OID 292269)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_studentclass ALTER COLUMN recid SET DEFAULT nextval('tb_xml_studentclass_recid_seq'::regclass);


--
-- TOC entry 5056 (class 2604 OID 292286)
-- Name: recid; Type: DEFAULT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_studentoffering ALTER COLUMN recid SET DEFAULT nextval('tb_xml_studentoffering_recid_seq'::regclass);


--
-- TOC entry 5080 (class 2606 OID 291890)
-- Name: pkey_room_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_room
    ADD CONSTRAINT pkey_room_recid PRIMARY KEY (recid);


--
-- TOC entry 5104 (class 2606 OID 292348)
-- Name: pkey_sharingmatrix_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_sharingmatrix
    ADD CONSTRAINT pkey_sharingmatrix_recid PRIMARY KEY (recid);


--
-- TOC entry 5084 (class 2606 OID 291944)
-- Name: pkey_sharingpattern_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_sharingpattern
    ADD CONSTRAINT pkey_sharingpattern_recid PRIMARY KEY (recid);


--
-- TOC entry 5106 (class 2606 OID 292459)
-- Name: pkey_timetabledefault_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_timetabledefault
    ADD CONSTRAINT pkey_timetabledefault_recid PRIMARY KEY (recid);


--
-- TOC entry 5086 (class 2606 OID 292016)
-- Name: pkey_xml_class_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_class
    ADD CONSTRAINT pkey_xml_class_recid PRIMARY KEY (recid);


--
-- TOC entry 5088 (class 2606 OID 292107)
-- Name: pkey_xml_classinstructor_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classinstructor
    ADD CONSTRAINT pkey_xml_classinstructor_recid PRIMARY KEY (recid);


--
-- TOC entry 5090 (class 2606 OID 292139)
-- Name: pkey_xml_classroom_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classroom
    ADD CONSTRAINT pkey_xml_classroom_recid PRIMARY KEY (recid);


--
-- TOC entry 5092 (class 2606 OID 292172)
-- Name: pkey_xml_classtime_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_classtime
    ADD CONSTRAINT pkey_xml_classtime_recid PRIMARY KEY (recid);


--
-- TOC entry 5108 (class 2606 OID 300606)
-- Name: pkey_xml_constraintclass_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_constraintclass
    ADD CONSTRAINT pkey_xml_constraintclass_recid PRIMARY KEY (recid);


--
-- TOC entry 5110 (class 2606 OID 300623)
-- Name: pkey_xml_constraintparentclass_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_constraintparentclass
    ADD CONSTRAINT pkey_xml_constraintparentclass_recid PRIMARY KEY (recid);


--
-- TOC entry 5094 (class 2606 OID 292231)
-- Name: pkey_xml_groupconstraint_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_groupconstraint
    ADD CONSTRAINT pkey_xml_groupconstraint_recid PRIMARY KEY (recid);


--
-- TOC entry 5102 (class 2606 OID 292306)
-- Name: pkey_xml_prohibitedclass_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_prohibitedclass
    ADD CONSTRAINT pkey_xml_prohibitedclass_recid PRIMARY KEY (recid);


--
-- TOC entry 5082 (class 2606 OID 291908)
-- Name: pkey_xml_room_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_room
    ADD CONSTRAINT pkey_xml_room_recid PRIMARY KEY (recid);


--
-- TOC entry 5096 (class 2606 OID 292252)
-- Name: pkey_xml_student_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_student
    ADD CONSTRAINT pkey_xml_student_recid PRIMARY KEY (recid);


--
-- TOC entry 5098 (class 2606 OID 292274)
-- Name: pkey_xml_studentclass_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_studentclass
    ADD CONSTRAINT pkey_xml_studentclass_recid PRIMARY KEY (recid);


--
-- TOC entry 5100 (class 2606 OID 292291)
-- Name: pkey_xml_studentoffering_recid; Type: CONSTRAINT; Schema: timetable2; Owner: spadmin
--

ALTER TABLE ONLY tb_xml_studentoffering
    ADD CONSTRAINT pkey_xml_studentoffering_recid PRIMARY KEY (recid);


-- Completed on 2017-06-12 23:39:20 GMT

--
-- PostgreSQL database dump complete
--

