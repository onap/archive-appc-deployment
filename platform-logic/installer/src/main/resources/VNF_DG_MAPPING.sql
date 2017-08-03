
-- ============LICENSE_START=======================================================
-- APPC
-- ================================================================================
-- Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
-- ================================================================================
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--      http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- ============LICENSE_END=========================================================


--
-- Table structure for table `VNF_DG_MAPPING`
--

USE sdnctl;
DROP TABLE IF EXISTS `VNF_DG_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `VNF_DG_MAPPING` (
  `action` varchar(50) NOT NULL,
  `api_version` varchar(50) DEFAULT NULL,
  `vnf_type` varchar(50) DEFAULT NULL,
  `vnf_version` varchar(50) DEFAULT NULL,
  `dg_name` varchar(50) NOT NULL,
  `dg_version` varchar(50) DEFAULT NULL,
  `dg_module` varchar(50) NOT NULL,
  UNIQUE KEY `INPUT_CONSTRAINT` (`action`,`api_version`,`vnf_type`,`vnf_version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VNF_DG_MAPPING`
--

LOCK TABLES `VNF_DG_MAPPING` WRITE;
/*!40000 ALTER TABLE `VNF_DG_MAPPING` DISABLE KEYS */;
INSERT INTO `VNF_DG_MAPPING` VALUES ('Restart','2.01','','','legacy_operation','2.0.0','APPC'), ('Restart','2.00','','','Restart_VNF','2.0.1','APPC');

/*!40000 ALTER TABLE `VNF_DG_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;
