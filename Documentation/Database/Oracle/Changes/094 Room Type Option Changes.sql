/*
 * Licensed to The Apereo Foundation under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.
 *
 * The Apereo Foundation licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
*/

alter table room_type_option add break_time number(10) default 0;
alter table room_type_option add constraint nn_rtype_opt_break check (break_time is not null);

alter table room_type_option add department_id number(20,0);
alter table room_type_option drop primary key drop index;
alter table room_type_option drop constraint fk_rtype_option_session;
alter table room_type_option drop constraint nn_rtype_opt_session;

insert into room_type_option (room_type, department_id, status, message)
	select o.room_type, d.uniqueid, o.status, o.message
	from room_type_option o, department d
	where d.session_id = o.session_id and d.allow_events = 1 and o.status = 1 and (
		(select count(*) from room r where r.event_dept_id = d.uniqueid and r.room_type = o.room_type) > 0 or
		(select count(*) from non_university_location r where r.event_dept_id = d.uniqueid and r.room_type = o.room_type) > 0
	);
delete from room_type_option where department_id is null or department_id = 0;
		
alter table room_type_option add constraint nn_rtype_opt_department check (department_id is not null);
alter table room_type_option add constraint pk_room_type_option primary key (room_type, department_id);

alter table room_type_option 
	add constraint fk_rtype_option_department foreign key (department_id)
	references department (uniqueid) on delete cascade;

alter table room_type_option drop column session_id;

insert into rights (select role_id, 'EventRoomTypes' as value from roles where reference = 'Administrator');
insert into rights (select role_id, 'EventRoomTypeEdit' as value from roles where reference = 'Administrator');
insert into rights (select role_id, 'EventRoomTypes' as value from roles where reference = 'Sysadmin');
insert into rights (select role_id, 'EventRoomTypeEdit' as value from roles where reference = 'Sysadmin');
insert into rights (select role_id, 'EventRoomTypes' as value from roles where reference = 'Event Mgr');
insert into rights (select role_id, 'EventRoomTypeEdit' as value from roles where reference = 'Event Mgr');
		
/*
 * Update database version
 */

update application_config set value='94' where name='tmtbl.db.version';

commit;
