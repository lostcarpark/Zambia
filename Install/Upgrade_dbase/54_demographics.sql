## This script add tables, fields and initial values for demographics
##
##	Created by Syd Weinstein on September 22, 2020
## 	Copyright (c) 2020 by Peter Olszowka. All rights reserved. See copyright document for more details.
##
drop table if exists ParticipantDemographics;
drop table if exists DemographicOptionConfig;
drop table if exists DemographicConfig;
drop table if exists DemographicTypeDefaults;
drop table if exists DemographicTypes;

CREATE TABLE DemographicTypes (
	typeid int NOT NULL AUTO_INCREMENT,
	shortname varchar(100) NOT NULL,
	description varchar(1024) DEFAULT NULL,
	current tinyint DEFAULT '0',
	display_order int NOT NULL,
	PRIMARY KEY (typeid)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Demographic Type info.';

INSERT INTO DemographicTypes (typeid, shortname, description, current, display_order)
VALUES
	(10, 'single-radio', 'Radio button list, select one of many', 1, 10),
	(20, 'single-pulldown', 'Select list, select one of many', 1, 20),
	(30, 'multi-select list', 'Select list, select multiple of many with Ctrl/click', 1, 30),
	(40, 'multi-checkbox list', 'Checkbox list, check multiple of many', 1, 31),
	(50, 'multi-display', 'left<-->right select boxes, move selected options to right box', 1, 32),
	(60, 'openend', 'Single line of text', 1, 40),
	(70, 'text', 'Multi-line text box', 1, 50),
	(80, 'numberselect', 'Number from min to max, ascending or descending', 1, 60),
    (90, 'number', 'Integer fill in the blank', 1, 61),
	(100, 'monthnum', 'Months by number (1-12)', 1, 140),
	(110, 'monthabv', 'Months by abbreviation (Jan-Dec)', 1, 150),
	(120, 'monthyear', 'Months by abbreviation (Jan-Dec, current year-1900)', 1, 160),
	(130, 'country', 'Country List', 1, 170),
	(140, 'states', 'State/Province List', 1, 180);
    
CREATE TABLE DemographicTypeDefaults (
	typeid int NOT NULL,
    ordinal int NOT NULL,
    value varchar(512) NOT NULL,
	display_order int NOT NULL,
	optionshort varchar(64) NOT NULL,
	optionhover varchar(512) DEFAULT NULL,
	allowothertext bool DEFAULT '0',
    PRIMARY KEY (typeid, ordinal),
	FOREIGN KEY (typeid) REFERENCES DemographicTypes(typeid)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Demographic Type Default options';

INSERT INTO DemographicTypeDefaults (typeid, ordinal, value, display_order, optionshort, optionhover, allowothertext)
VALUES
	(100, 1, '1', 1, 'Jan', 'January', 0),
	(100, 2, '2', 2, 'Feb', 'February', 0),
	(100, 3, '3', 3, 'Mar', 'March', 0),
	(100, 4, '4', 4, 'Apr', 'April', 0),
	(100, 5, '5', 5, 'May', 'May', 0),
	(100, 6, '6', 6, 'Jun', 'June', 0),
	(100, 7, '7', 7, 'Jul', 'July', 0),
	(100, 8, '8', 8, 'Aug', 'August', 0),
	(100, 9, '9', 9, 'Sep', 'September', 0),
	(100, 10, '10', 10, 'Oct', 'October', 0),
	(100, 11, '11', 11, 'Nov', 'November', 0),
	(100, 12, '12', 12, 'Dec', 'December', 0),
	(110, 1, 'Jan', 1, 'Jan', 'January', 0),
	(110, 2, 'Feb', 2, 'Feb', 'February', 0),
	(110, 3, 'Mar', 3, 'Mar', 'March', 0),
	(110, 4, 'Apr', 4, 'Apr', 'April', 0),
	(110, 5, 'May', 5, 'May', 'May', 0),
	(110, 6, 'Jun', 6, 'Jun', 'June', 0),
	(110, 7, 'Jul', 7, 'Jul', 'July', 0),
	(110, 8, 'Aug', 8, 'Aug', 'August', 0),
	(110, 9, 'Sep', 9, 'Sep', 'September', 0),
	(110, 10, 'Oct', 10, 'Oct', 'October', 0),
	(110, 11, 'Nov', 11, 'Nov', 'November', 0),
	(110, 12, 'Dec', 12, 'Dec', 'December', 0),
	(120, 1, 'Jan', 1, 'Jan', 'January', 0),
	(120, 2, 'Feb', 2, 'Feb', 'February', 0),
	(120, 3, 'Mar', 3, 'Mar', 'March', 0),
	(120, 4, 'Apr', 4, 'Apr', 'April', 0),
	(120, 5, 'May', 5, 'May', 'May', 0),
	(120, 6, 'Jun', 6, 'Jun', 'June', 0),
	(120, 7, 'Jul', 7, 'Jul', 'July', 0),
	(120, 8, 'Aug', 8, 'Aug', 'August', 0),
	(120, 9, 'Sep', 9, 'Sep', 'September', 0),
	(120, 10, 'Oct', 10, 'Oct', 'October', 0),
	(120, 11, 'Nov', 11, 'Nov', 'November', 0),
	(120, 12, 'Dec', 12, 'Dec', 'December', 0),
	(130, 1, 'US', 1, 'United States', NULL, 0),
	(130,2,'CA',2,'Canada',NULL,0),
	(130,3,'AF',3,'Afghanistan',NULL,0),
	(130,4,'AX',4,'Aland Islands',NULL,0),
	(130,5,'AL',5,'Albania',NULL,0),
	(130,6,'DZ',6,'Algeria',NULL,0),
	(130,7,'AS',7,'American Samoa',NULL,0),
	(130,8,'AD',8,'Andorra',NULL,0),
	(130,9,'AO',9,'Angola',NULL,0),
	(130,10,'AI',10,'Anguilla',NULL,0),
	(130,11,'AQ',11,'Antarctica',NULL,0),
	(130,12,'AG',12,'Antigua and Barbuda',NULL,0),
	(130,13,'AR',13,'Argentina',NULL,0),
	(130,14,'AM',14,'Armenia',NULL,0),
	(130,15,'AW',15,'Aruba',NULL,0),
	(130,16,'AU',16,'Australia',NULL,0),
	(130,17,'AT',17,'Austria',NULL,0),
	(130,18,'AZ',18,'Azerbaijan',NULL,0),
	(130,19,'BS',19,'Bahamas',NULL,0),
	(130,20,'BH',20,'Bahrain',NULL,0),
	(130,21,'BD',21,'Bangladesh',NULL,0),
	(130,22,'BB',22,'Barbados',NULL,0),
	(130,23,'BY',23,'Belarus',NULL,0),
	(130,24,'BE',24,'Belgium',NULL,0),
	(130,25,'BZ',25,'Belize',NULL,0),
	(130,26,'BJ',26,'Benin',NULL,0),
	(130,27,'BM',27,'Bermuda',NULL,0),
	(130,28,'BT',28,'Bhutan',NULL,0),
	(130,29,'BO',29,'Bolivia',NULL,0),
	(130,30,'BA',30,'Bosnia and Herzegovina',NULL,0),
	(130,31,'BW',31,'Botswana',NULL,0),
	(130,32,'BV',32,'Bouvet Island',NULL,0),
	(130,33,'BR',33,'Brazil',NULL,0),
	(130,34,'VG',34,'British Virgin Islands',NULL,0),
	(130,35,'IO',35,'British Indian Ocean Territory',NULL,0),
	(130,36,'BN',36,'Brunei Darussalam',NULL,0),
	(130,37,'BG',37,'Bulgaria',NULL,0),
	(130,38,'BF',38,'Burkina Faso',NULL,0),
	(130,39,'BI',39,'Burundi',NULL,0),
	(130,40,'KH',40,'Cambodia',NULL,0),
	(130,41,'CM',41,'Cameroon',NULL,0),
	(130,42,'CV',42,'Cape Verde',NULL,0),
	(130,43,'KY',43,'Cayman Islands',NULL,0),
	(130,44,'CF',44,'Central African Republic',NULL,0),
	(130,45,'TD',45,'Chad',NULL,0),
	(130,46,'CL',46,'Chile',NULL,0),
	(130,47,'CN',47,'China',NULL,0),
	(130,48,'HK',48,'Hong Kong, SAR China',NULL,0),
	(130,49,'MO',49,'Macao, SAR China',NULL,0),
	(130,50,'CX',50,'Christmas Island',NULL,0),
	(130,51,'CC',51,'Cocos (Keeling Islands)',NULL,0),
	(130,52,'CO',52,'Colombia',NULL,0),
	(130,53,'KM',53,'Comoros',NULL,0),
	(130,54,'CG',54,'Congo (Brazzaville)',NULL,0),
	(130,55,'CD',55,'Congo, (Kinshasa)',NULL,0),
	(130,56,'CK',56,'Cook Islands',NULL,0),
	(130,57,'CR',57,'Costa Rica',NULL,0),
	(130,58,'CI',58,'Côte dNULLIvoire','',0),
	(130,59,'HR',59,'Croatia',NULL,0),
	(130,60,'CU',60,'Cuba',NULL,0),
	(130,61,'CY',61,'Cyprus',NULL,0),
	(130,62,'CZ',62,'Czech Republic',NULL,0),
	(130,63,'DK',63,'Denmark',NULL,0),
	(130,64,'DJ',64,'Djibouti',NULL,0),
	(130,65,'DM',65,'Dominica',NULL,0),
	(130,66,'DO',66,'Dominican Republic',NULL,0),
	(130,67,'EC',67,'Ecuador',NULL,0),
	(130,68,'EG',68,'Egypt',NULL,0),
	(130,69,'SV',69,'El Salvador',NULL,0),
	(130,70,'GQ',70,'Equatorial Guinea',NULL,0),
	(130,71,'ER',71,'Eritrea',NULL,0),
	(130,72,'EE',72,'Estonia',NULL,0),
	(130,73,'ET',73,'Ethiopia',NULL,0),
	(130,74,'FK',74,'Falkland Islands (Malvinas)',NULL,0),
	(130,75,'FO',75,'Faroe Islands',NULL,0),
	(130,76,'FJ',76,'Fiji',NULL,0),
	(130,77,'FI',77,'Finland',NULL,0),
	(130,78,'FR',78,'France',NULL,0),
	(130,79,'GF',79,'French Guiana',NULL,0),
	(130,80,'PF',80,'French Polynesia',NULL,0),
	(130,81,'TF',81,'French Southern Territories',NULL,0),
	(130,82,'GA',82,'Gabon',NULL,0),
	(130,83,'GM',83,'Gambia',NULL,0),
	(130,84,'GE',84,'Georgia',NULL,0),
	(130,85,'DE',85,'Germany',NULL,0),
	(130,86,'GH',86,'Ghana',NULL,0),
	(130,87,'GI',87,'Gibraltar',NULL,0),
	(130,88,'GR',88,'Greece',NULL,0),
	(130,89,'GL',89,'Greenland',NULL,0),
	(130,90,'GD',90,'Grenada',NULL,0),
	(130,91,'GP',91,'Guadeloupe',NULL,0),
	(130,92,'GU',92,'Guam',NULL,0),
	(130,93,'GT',93,'Guatemala',NULL,0),
	(130,94,'GG',94,'Guernsey',NULL,0),
	(130,95,'GN',95,'Guinea',NULL,0),
	(130,96,'GW',96,'Guinea-Bissau',NULL,0),
	(130,97,'GY',97,'Guyana',NULL,0),
	(130,98,'HT',98,'Haiti',NULL,0),
	(130,99,'HM',99,'Heard and Mcdonald Islands',NULL,0),
	(130,100,'VA',100,'Holy See (Vatican City State)',NULL,0),
	(130,101,'HN',101,'Honduras',NULL,0),
	(130,102,'HU',102,'Hungary',NULL,0),
	(130,103,'IS',103,'Iceland',NULL,0),
	(130,104,'IN',104,'India',NULL,0),
	(130,105,'ID',105,'Indonesia',NULL,0),
	(130,106,'IR',106,'Iran, Islamic Republic of',NULL,0),
	(130,107,'IQ',107,'Iraq',NULL,0),
	(130,108,'IE',108,'Ireland',NULL,0),
	(130,109,'IM',109,'Isle of Man',NULL,0),
	(130,110,'IL',110,'Israel',NULL,0),
	(130,111,'IT',111,'Italy',NULL,0),
	(130,112,'JM',112,'Jamaica',NULL,0),
	(130,113,'JP',113,'Japan',NULL,0),
	(130,114,'JE',114,'Jersey',NULL,0),
	(130,115,'JO',115,'Jordan',NULL,0),
	(130,116,'KZ',116,'Kazakhstan',NULL,0),
	(130,117,'KE',117,'Kenya',NULL,0),
	(130,118,'KI',118,'Kiribati',NULL,0),
	(130,119,'KP',119,'Korea (North)',NULL,0),
	(130,120,'KR',120,'Korea (South)',NULL,0),
	(130,121,'KW',121,'Kuwait',NULL,0),
	(130,122,'KG',122,'Kyrgyzstan',NULL,0),
	(130,123,'LA',123,'Lao PDR',NULL,0),
	(130,124,'LV',124,'Latvia',NULL,0),
	(130,125,'LB',125,'Lebanon',NULL,0),
	(130,126,'LS',126,'Lesotho',NULL,0),
	(130,127,'LR',127,'Liberia',NULL,0),
	(130,128,'LY',128,'Libya',NULL,0),
	(130,129,'LI',129,'Liechtenstein',NULL,0),
	(130,130,'LT',130,'Lithuania',NULL,0),
	(130,131,'LU',131,'Luxembourg',NULL,0),
	(130,132,'MK',132,'Macedonia, Republic of',NULL,0),
	(130,133,'MG',133,'Madagascar',NULL,0),
	(130,134,'MW',134,'Malawi',NULL,0),
	(130,135,'MY',135,'Malaysia',NULL,0),
	(130,136,'MV',136,'Maldives',NULL,0),
	(130,137,'ML',137,'Mali',NULL,0),
	(130,138,'MT',138,'Malta',NULL,0),
	(130,139,'MH',139,'Marshall Islands',NULL,0),
	(130,140,'MQ',140,'Martinique',NULL,0),
	(130,141,'MR',141,'Mauritania',NULL,0),
	(130,142,'MU',142,'Mauritius',NULL,0),
	(130,143,'YT',143,'Mayotte',NULL,0),
	(130,144,'MX',144,'Mexico',NULL,0),
	(130,145,'FM',145,'Micronesia, Federated States of',NULL,0),
	(130,146,'MD',146,'Moldova, Republic of',NULL,0),
	(130,147,'MC',147,'Monaco',NULL,0),
	(130,148,'MN',148,'Mongolia',NULL,0),
	(130,149,'ME',149,'Montenegro',NULL,0),
	(130,150,'MS',150,'Montserrat',NULL,0),
	(130,151,'MA',151,'Morocco',NULL,0),
	(130,152,'MZ',152,'Mozambique',NULL,0),
	(130,153,'MM',153,'Myanmar',NULL,0),
	(130,154,'NA',154,'Namibia',NULL,0),
	(130,155,'NR',155,'Nauru',NULL,0),
	(130,156,'NP',156,'Nepal',NULL,0),
	(130,157,'NL',157,'Netherlands',NULL,0),
	(130,158,'AN',158,'Netherlands Antilles',NULL,0),
	(130,159,'NC',159,'New Caledonia',NULL,0),
	(130,160,'NZ',160,'New Zealand',NULL,0),
	(130,161,'NI',161,'Nicaragua',NULL,0),
	(130,162,'NE',162,'Niger',NULL,0),
	(130,163,'NG',163,'Nigeria',NULL,0),
	(130,164,'NU',164,'Niue',NULL,0),
	(130,165,'NF',165,'Norfolk Island',NULL,0),
	(130,166,'MP',166,'Northern Mariana Islands',NULL,0),
	(130,167,'NO',167,'Norway',NULL,0),
	(130,168,'OM',168,'Oman',NULL,0),
	(130,169,'PK',169,'Pakistan',NULL,0),
	(130,170,'PW',170,'Palau',NULL,0),
	(130,171,'PS',171,'Palestinian Territory',NULL,0),
	(130,172,'PA',172,'Panama',NULL,0),
	(130,173,'PG',173,'Papua New Guinea',NULL,0),
	(130,174,'PY',174,'Paraguay',NULL,0),
	(130,175,'PE',175,'Peru',NULL,0),
	(130,176,'PH',176,'Philippines',NULL,0),
	(130,177,'PN',177,'Pitcairn',NULL,0),
	(130,178,'PL',178,'Poland',NULL,0),
	(130,179,'PT',179,'Portugal',NULL,0),
	(130,180,'PR',180,'Puerto Rico',NULL,0),
	(130,181,'QA',181,'Qatar',NULL,0),
	(130,182,'RE',182,'Réunion',NULL,0),
	(130,183,'RO',183,'Romania',NULL,0),
	(130,184,'RU',184,'Russian Federation',NULL,0),
	(130,185,'RW',185,'Rwanda',NULL,0),
	(130,186,'BL',186,'Saint-Barthélemy',NULL,0),
	(130,187,'SH',187,'Saint Helena',NULL,0),
	(130,188,'KN',188,'Saint Kitts and Nevis',NULL,0),
	(130,189,'LC',189,'Saint Lucia',NULL,0),
	(130,190,'MF',190,'Saint-Martin (French)',NULL,0),
	(130,191,'PM',191,'Saint Pierre and Miquelon',NULL,0),
	(130,192,'VC',192,'Saint Vincent and Grenadines',NULL,0),
	(130,193,'WS',193,'Samoa',NULL,0),
	(130,194,'SM',194,'San Marino',NULL,0),
	(130,195,'ST',195,'Sao Tome and Principe',NULL,0),
	(130,196,'SA',196,'Saudi Arabia',NULL,0),
	(130,197,'SN',197,'Senegal',NULL,0),
	(130,198,'RS',198,'Serbia',NULL,0),
	(130,199,'SC',199,'Seychelles',NULL,0),
	(130,200,'SL',200,'Sierra Leone',NULL,0),
	(130,201,'SG',201,'Singapore',NULL,0),
	(130,202,'SK',202,'Slovakia',NULL,0),
	(130,203,'SI',203,'Slovenia',NULL,0),
	(130,204,'SB',204,'Solomon Islands',NULL,0),
	(130,205,'SO',205,'Somalia',NULL,0),
	(130,206,'ZA',206,'South Africa',NULL,0),
	(130,207,'GS',207,'South Georgia and the South Sandwich Islands',NULL,0),
	(130,209,'SS',209,'South Sudan',NULL,0),
	(130,210,'ES',210,'Spain',NULL,0),
	(130,211,'LK',211,'Sri Lanka',NULL,0),
	(130,212,'SD',212,'Sudan',NULL,0),
	(130,213,'SR',213,'Suriname',NULL,0),
	(130,214,'SJ',214,'Svalbard and Jan Mayen Islands',NULL,0),
	(130,215,'SZ',215,'Swaziland',NULL,0),
	(130,216,'SE',216,'Sweden',NULL,0),
	(130,217,'CH',217,'Switzerland',NULL,0),
	(130,218,'SY',218,'Syrian Arab Republic (Syria)',NULL,0),
	(130,219,'TW',219,'Taiwan, Republic of China',NULL,0),
	(130,220,'TJ',220,'Tajikistan',NULL,0),
	(130,221,'TZ',221,'Tanzania, United Republic of',NULL,0),
	(130,222,'TH',222,'Thailand',NULL,0),
	(130,223,'TL',223,'Timor-Leste',NULL,0),
	(130,224,'TG',224,'Togo',NULL,0),
	(130,225,'TK',225,'Tokelau',NULL,0),
	(130,226,'TO',226,'Tonga',NULL,0),
	(130,227,'TT',227,'Trinidad and Tobago',NULL,0),
	(130,228,'TN',228,'Tunisia',NULL,0),
	(130,229,'TR',229,'Turkey',NULL,0),
	(130,230,'TM',230,'Turkmenistan',NULL,0),
	(130,231,'TC',231,'Turks and Caicos Islands',NULL,0),
	(130,232,'TV',232,'Tuvalu',NULL,0),
	(130,233,'UG',233,'Uganda',NULL,0),
	(130,234,'UA',234,'Ukraine',NULL,0),
	(130,235,'AE',235,'United Arab Emirates',NULL,0),
	(130,236,'GB',236,'United Kingdom',NULL,0),
	(130,237,'UM',237,'US Minor Outlying Islands',NULL,0),
	(130,238,'UY',238,'Uruguay',NULL,0),
	(130,239,'UZ',239,'Uzbekistan',NULL,0),
	(130,240,'VU',240,'Vanuatu',NULL,0),
	(130,241,'VE',241,'Venezuela (Bolivarian Republic)',NULL,0),
	(130,242,'VN',242,'Viet Nam',NULL,0),
	(130,243,'VI',243,'Virgin Islands, US',NULL,0),
	(130,244,'WF',244,'Wallis and Futuna Islands',NULL,0),
	(130,245,'EH',245,'Western Sahara',NULL,0),
	(130,246,'YE',246,'Yemen',NULL,0),
	(130,247,'ZM',247,'Zambia',NULL,0),
	(130,248,'ZW',248,'Zimbabwe',NULL,0),
	(140, 1, 'AL', 1, 'AL', 'Alabama',0),
	(140, 2, 'AK', 2, 'AK', 'Alaska',0),
	(140, 3, 'AB', 3, 'AB', 'Alberta',0),
	(140, 4, 'AS', 4, 'AS', 'American Samoa',0),
	(140, 5, 'AZ', 5, 'AZ', 'Arizona',0),
	(140, 6, 'AR', 6, 'AR', 'Arkansas',0),
	(140, 7, 'BC', 7, 'BC', 'British Columbia',0),
	(140, 8, 'CA', 8, 'CA', 'California',0),
	(140, 9, 'CO', 9, 'CO', 'Colorado',0),
	(140, 10, 'CT', 10, 'CT', 'Connecticut',0),
	(140, 11, 'DE', 11, 'DE', 'Delaware',0),
	(140, 12, 'DC', 12, 'DC', 'District of Columbia',0),
	(140, 13, 'FL', 13, 'FL', 'Florida',0),
	(140, 14, 'GA', 14, 'GA', 'Georgia',0),
	(140, 15, 'GU', 15, 'GU', 'Guam',0),
	(140, 16, 'HI', 16, 'HI', 'Hawaii',0),
	(140, 17, 'ID', 17, 'ID', 'Idaho',0),
	(140, 18, 'IL', 18, 'IL', 'Illinois',0),
	(140, 19, 'IN', 19, 'IN', 'Indiana',0),
	(140, 20, 'IA', 20, 'IA', 'Iowa',0),
	(140, 21, 'KS', 21, 'KS', 'Kansas',0),
	(140, 22, 'KY', 22, 'KY', 'Kentucky',0),
	(140, 23, 'LA', 23, 'LA', 'Louisiana',0),
	(140, 24, 'ME', 24, 'ME', 'Maine',0),
	(140, 25, 'MB', 25, 'MB', 'Manitoba',0),
	(140, 26, 'MH', 26, 'MH', 'Marshall Islands',0),
	(140, 27, 'MD', 27, 'MD', 'Maryland',0),
	(140, 28, 'MA', 28, 'MA', 'Massachusetts',0),
	(140, 29, 'MI', 29, 'MI', 'Michigan',0),
	(140, 30, 'FM', 30, 'FM', 'Micronesia',0),
	(140, 31, 'MN', 31, 'MN', 'Minnesota',0),
	(140, 32, 'MS', 32, 'MS', 'Mississippi',0),
	(140, 33, 'MO', 33, 'MO', 'Missouri',0),
	(140, 34, 'MT', 34, 'MT', 'Montana',0),
	(140, 35, 'NE', 35, 'NE', 'Nebraska',0),
	(140, 36, 'NV', 36, 'NV', 'Nevada',0),
	(140, 37, 'NB', 37, 'NB', 'New Brunswick',0),
	(140, 38, 'NH', 38, 'NH', 'New Hampshire',0),
	(140, 39, 'NJ', 39, 'NJ', 'New Jersey',0),
	(140, 40, 'NM', 40, 'NM', 'New Mexico',0),
	(140, 41, 'NY', 41, 'NY', 'New York',0),
	(140, 42, 'NL', 42, 'NL', 'Newfoundland and Labrador',0),
	(140, 43, 'NC', 43, 'NC', 'North Carolina',0),
	(140, 44, 'ND', 44, 'ND', 'North Dakota',0),
	(140, 45, 'MP', 45, 'MP', 'Northern Marianas',0),
	(140, 46, 'NT', 46, 'NT', 'Northwest Territories',0),
	(140, 47, 'NS', 47, 'NS', 'Nova Scotia',0),
	(140, 48, 'NU', 48, 'NU', 'Nunavut',0),
	(140, 49, 'OH', 49, 'OH', 'Ohio',0),
	(140, 50, 'OK', 50, 'OK', 'Oklahoma',0),
	(140, 51, 'ON', 51, 'ON', 'Ontario',0),
	(140, 52, 'OR', 52, 'OR', 'Oregon',0),
	(140, 53, 'PW', 53, 'PW', 'Palau',0),
	(140, 54, 'PA', 54, 'PA', 'Pennsylvania',0),
	(140, 55, 'PE', 55, 'PE', 'Prince Edward Island',0),
	(140, 56, 'PR', 56, 'PR', 'Puerto Rico',0),
	(140, 57, 'QC', 57, 'QC', 'Quebec',0),
	(140, 58, 'RI', 58, 'RI', 'Rhode Island',0),
	(140, 59, 'SK', 59, 'SK', 'Saskatchewan',0),
	(140, 60, 'SC', 60, 'SC', 'South Carolina',0),
	(140, 61, 'SD', 61, 'SD', 'South Dakota',0),
	(140, 62, 'TN', 62, 'TN', 'Tennessee',0),
	(140, 63, 'TX', 63, 'TX', 'Texas',0),
	(140, 64, 'UT', 64, 'UT', 'Utah',0),
	(140, 65, 'VT', 65, 'VT', 'Vermont',0),
	(140, 66, 'VI', 66, 'VI', 'Virgin Islands',0),
	(140, 67, 'VA', 67, 'VA', 'Virginia',0),
	(140, 68, 'WA', 68, 'WA', 'Washington',0),
	(140, 69, 'WV', 69, 'WV', 'West Virginia',0),
	(140, 70, 'WI', 70, 'WI', 'Wisconsin',0),
	(140, 71, 'WY', 71, 'WY', 'Wyoming',0),
	(140, 72, 'YT', 72, 'YT', 'Yukon',0);

CREATE TABLE DemographicConfig (
	demographicid int NOT NULL AUTO_INCREMENT,
	shortname varchar(100) NOT NULL,
	description varchar(1024) DEFAULT NULL,
	prompt varchar(512) NOT NULL,
	hover varchar(8192) DEFAULT NULL,
	display_order int NOT NULL,
	typeid int NOT NULL,
	required bool NOT NULL DEFAULT '0',
	publish bool NOT NULL DEFAULT '0',
	privacy_user bool NOT NULL DEFAULT '0',
	searchable bool NOT NULL DEFAULT '0',
	ascending bool NOT NULL DEFAULT '1',
	min_value int DEFAULT NULL,
	max_value int DEFAULT NULL,
	PRIMARY KEY (demographicid),
	FOREIGN KEY (typeid) REFERENCES DemographicTypes(typeid)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Demographic Info.';

CREATE TABLE DemographicOptionConfig (
	demographicid int NOT NULL,
	ordinal int NOT NULL,
	value varchar(512) NOT NULL,
	display_order int NOT NULL,
	optionshort varchar(64) NOT NULL,
	optionhover varchar(512) DEFAULT NULL,
	allowothertext bool DEFAULT '0',
	PRIMARY KEY (demographicid, ordinal),
	FOREIGN KEY (demographicid) REFERENCES DemographicConfig(demographicid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Demographic Option Info.';

CREATE TABLE ParticipantDemographics (
	participantid varchar(15) NOT NULL,
	demographicid int NOT NULL,
	display_order int NOT NULL,
	privacy_setting bool NOT NULL DEFAULT '0',
	value varchar(8192),
	othertext varchar(512),
	PRIMARY KEY (participantid, demographicid),
	FOREIGN KEY (participantid) REFERENCES Participants(badgeid) ON DELETE CASCADE,
	FOREIGN KEY (demographicid) REFERENCES DemographicConfig(demographicid) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Participant Demographic Info.';

##INSERT INTO PatchLog (patchname) VALUES ('54_demographics.sql');
