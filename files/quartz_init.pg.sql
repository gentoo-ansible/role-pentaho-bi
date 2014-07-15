-- Slightly modified script from Pentaho distribution.

CREATE TABLE IF NOT EXISTS qrtz5_job_details
  (
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE BOOL NOT NULL,
    IS_VOLATILE BOOL NOT NULL,
    IS_STATEFUL BOOL NOT NULL,
    REQUESTS_RECOVERY BOOL NOT NULL,
    JOB_DATA BYTEA NULL,
    PRIMARY KEY (JOB_NAME,JOB_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_job_listeners
  (
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    JOB_LISTENER VARCHAR(200) NOT NULL,
    PRIMARY KEY (JOB_NAME,JOB_GROUP,JOB_LISTENER),
    FOREIGN KEY (JOB_NAME,JOB_GROUP)
	REFERENCES qrtz5_JOB_DETAILS(JOB_NAME,JOB_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_triggers
  (
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    IS_VOLATILE BOOL NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT NULL,
    PREV_FIRE_TIME BIGINT NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT NOT NULL,
    END_TIME BIGINT NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT NULL,
    JOB_DATA BYTEA NULL,
    PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (JOB_NAME,JOB_GROUP)
	REFERENCES qrtz5_job_details(JOB_NAME,JOB_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_simple_triggers
  (
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT NOT NULL,
    REPEAT_INTERVAL BIGINT NOT NULL,
    TIMES_TRIGGERED BIGINT NOT NULL,
    PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
	REFERENCES qrtz5_triggers(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_cron_triggers
  (
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(120) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
	REFERENCES qrtz5_triggers(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_blob_triggers
  (
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BYTEA NULL,
    PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES qrtz5_triggers(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_trigger_listeners
  (
    TRIGGER_NAME  VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    TRIGGER_LISTENER VARCHAR(200) NOT NULL,
    PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_LISTENER),
    FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
	REFERENCES qrtz5_triggers(TRIGGER_NAME,TRIGGER_GROUP)
);


CREATE TABLE IF NOT EXISTS qrtz5_calendars
  (
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BYTEA NOT NULL,
    PRIMARY KEY (CALENDAR_NAME)
);


CREATE TABLE IF NOT EXISTS qrtz5_paused_trigger_grps
  (
    TRIGGER_GROUP  VARCHAR(200) NOT NULL,
    PRIMARY KEY (TRIGGER_GROUP)
);

CREATE TABLE IF NOT EXISTS qrtz5_fired_triggers
  (
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    IS_VOLATILE BOOL NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_STATEFUL BOOL NULL,
    REQUESTS_RECOVERY BOOL NULL,
    PRIMARY KEY (ENTRY_ID)
);

CREATE TABLE IF NOT EXISTS qrtz5_scheduler_state
  (
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT NOT NULL,
    CHECKIN_INTERVAL BIGINT NOT NULL,
    PRIMARY KEY (INSTANCE_NAME)
);

CREATE TABLE IF NOT EXISTS qrtz5_locks
  (
    LOCK_NAME  VARCHAR(40) NOT NULL,
    PRIMARY KEY (LOCK_NAME)
);

-- Workaround for http://jira.pentaho.com/browse/BISERVER-10639?focusedCommentId=164380
CREATE TABLE IF NOT EXISTS "QRTZ_DUMMY"
  (
    ID BIGINT
);
COMMENT ON TABLE "QRTZ_DUMMY" IS 'This is workaround for bug BISERVER-10639 in Pentaho, do not drop it!';

INSERT INTO qrtz5_locks values('TRIGGER_ACCESS');
INSERT INTO qrtz5_locks values('JOB_ACCESS');
INSERT INTO qrtz5_locks values('CALENDAR_ACCESS');
INSERT INTO qrtz5_locks values('STATE_ACCESS');
INSERT INTO qrtz5_locks values('MISFIRE_ACCESS');
