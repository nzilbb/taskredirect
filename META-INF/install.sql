CREATE TABLE {0}_task_definition (
  task_id int(11) NOT NULL default 0,
  name varchar(500) NOT NULL default '',
  description text,
  valid_signature_pattern VARCHAR(50) NOT NULL default '',
  consent text,
  email_prompt text,
  email varchar(500) NOT NULL default '',
  already_done_message text,
  url varchar(500) NOT NULL default '',
  active int(1) NOT NULL default 0,
  max_participants int(11) NOT NULL default 0,
  inactive_message text,
  PRIMARY KEY  (task_id)
);

CREATE TABLE {0}_participant (
  participant_id int(11) NOT NULL AUTO_INCREMENT,
  worker_id varchar(500) NOT NULL default '',
  task_id int(11) NOT NULL default 0,
  signature varchar(500) NOT NULL default '',
  email varchar(500) NOT NULL default '',
  started datetime NULL,
  PRIMARY KEY  (participant_id)
);


/* version 0.61 */

CREATE TABLE {0}_task_field (
  task_id int(11) NOT NULL default 0,
  name varchar(200) NOT NULL default '',
  description text,
  PRIMARY KEY  (task_id, name)
);

CREATE TABLE {0}_participant_field (
  task_id int(11) NOT NULL default 0,
  participant_id int(11) NOT NULL default 0,
  name varchar(200) NOT NULL default '',
  value varchar(200) NOT NULL default '',
  PRIMARY KEY  (task_id, participant_id, name)
);

/* version 0.62 */
ALTER TABLE {0}_participant ADD COLUMN client_id VARCHAR(32) NULL;

/* version 0.70 */
ALTER TABLE {0}_task_field ADD COLUMN required tinyint default 0;
