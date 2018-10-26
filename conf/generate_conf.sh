#!/bin/bash
#

SDHUSER="sdhuser"
WEB_ROOT="/home/${SDHUSER}/web"
WEB="react/single"
BACKEND_ROOT="/home/${SDHUSER}/backend"
INSTALL_ROOT="/usr/local"
MONGODB_PORT="27017"

[ -f sdh.conf ] && . sdh.conf

SUPERVISORD_SAMPLE="[unix_http_server]\nfile=/var/supervisor/supervisor.sock\n\n[supervisord]\nlogfile=/var/supervisor/supervisord.log\nlogfile_maxbytes=50MB\nlogfile_backups=10\nloglevel=info\npidfile=/var/supervisor/supervisord.pid\nnodaemon=false\nminfds=1024\nminprocs=200\n\n[rpcinterface:supervisor]\nsupervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface\n\n[supervisorctl]\nserverurl=unix:///var/supervisor/supervisor.sock\n\n[program:run]\nuser=sdhuser\ncommand=/usr/local/venv/bin/gunicorn -b 0.0.0.0:3082 -k gevent -w 1 --reload --log-level=DEBUG -t 300 run82:program\ndirectory=/home/sdhuser/backend/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/run.log\nautostart=true\nautorestart=true\n\n[program:web]\nuser=sdhuser\ncommand=/usr/local/nodejs/bin/node web.js\ndirectory=/home/sdhuser/web/react/single\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/web.log\nautostart=true\nautorestart=true\n\n[program:mongod]\nuser=sdhuser\ncommand=/usr/local/mongodb/bin/mongod -f /usr/local/mongodb/conf/mongod.conf\ndirectory=/usr/local/mongodb\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/mongod.log\nautostart=true\nautorestart=true\n\n[program:run_m]\nuser=sdhuser\ncommand=/usr/local/venv/bin/python Scheduler.py\ndirectory=/home/sdhuser/backend/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/run_m.log\nautostart=true\nautorestart=true\n\n[program:fsu_receiver]\ncommand=/usr/local/venv/bin/celery -A fsu_receiver.celery worker --loglevel=info\ndirectory=/home/sdhuser/backend/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/fsu_receiver.log\nautostart=true\nautorestart=true\n\n[program:kafka]\ncommand=/usr/local/venv/bin/celery -A tasks worker -B --loglevel=info\ndirectory=/home/sdhuser/backend/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/kafka.log\nautostart=true\nautorestart=true\n"

SUPERVISORD_SERVICE_SAMPLE="[Unit]\nDescription=Process Monitoring and Control Daemon\nAfter=rc-local.service nss-user-lookup.target\n\n[Service]\nType=forking\nExecStart=${INSTALL_ROOT}/venv/bin/supervisord -c /etc/supervisord.conf\n\n[Install]\nWantedBy=multi-user.target"

MONGOD_SAMPLE="pidfilepath = ${INSTALL_ROOT}/mongodb/mongod.pid\ndbpath = ${INSTALL_ROOT}/mongodb/data\nlogpath = ${INSTALL_ROOT}/mongodb/log/mongod.log\nlogappend = true\nbind_ip = 0.0.0.0\nport = ${MONGODB_PORT}\n\nmaxConns = 20000"

RUN_XML_SAMPLE='<?xml version="1.0" encoding="utf-8"?>\n<service>\n<short>Python Server</short>\n<description>Python backend Server</description>\n<port protocol="tcp" port='"\"${BACKEND_PORT}\""'/>\n</service>\n'

WEB_XML_SAMPLE='<?xml version="1.0" encoding="utf-8"?>\n<service>\n<short>Node Server</short>\n<description>Node web Server</description>\n<port protocol="tcp" port='"\"${WEB_PORT}\""'/>\n</service>\n'

MONGODB_XML_SAMPLE='<?xml version="1.0" encoding="utf-8"?>\n<service>\n<short>Mongodb Server</short>\n<description>Mongodb Server</description>\n<port protocol="tcp" port='"\"${MONGODB_PORT}\""'/>\n</service>'

echo "generate conf/supervisord.conf"
echo -e ${SUPERVISORD_SAMPLE} > ${SCRIPT_DIR}/conf/supervisord.conf
echo "generate conf/supervisord.service"
echo -e ${SUPERVISORD_SERVICE_SAMPLE} > ${SCRIPT_DIR}/conf/supervisord.service
echo "generate conf/mongod.conf"
echo -e ${MONGOD_SAMPLE} > ${SCRIPT_DIR}/conf/mongod.conf
echo "generate conf/run.xml"
echo -e ${RUN_XML_SAMPLE} > ${SCRIPT_DIR}/conf/run.xml
echo "generate conf/web.xml"
echo -e ${WEB_XML_SAMPLE} > ${SCRIPT_DIR}/conf/web.xml
echo "generate conf/mongodb.xml"
echo -e ${MONGODB_XML_SAMPLE} > ${SCRIPT_DIR}/conf/mongodb.xml
