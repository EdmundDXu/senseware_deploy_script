#!/bin/bash
#

SDHUSER="sdhuser"
WEB_ROOT="/home/${SDHUSER}/web"
WEB="react/single"
BACKEND_ROOT="/home/${SDHUSER}/backend"
INSTALL_ROOT="/usr/local"
SCRIPT_DIR="/root/script"

[ -f sdh.conf ] && . sdh.conf

SUPERVISORD_SAMPLE="[unix_http_server]\nfile=/var/supervisor/supervisor.sock\n\n[supervisord]\nlogfile=/var/supervisor/supervisord.log\nlogfile_maxbytes=50MB\nlogfile_backups=10\nloglevel=info\npidfile=/var/supervisor/supervisord.pid\nnodaemon=false\nminfds=1024\nminprocs=200\n\n[rpcinterface:supervisor]\nsupervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface\n\n[supervisorctl]\nserverurl=unix:///var/supervisor/supervisor.sock\n\n[program:run]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/venv/bin/gunicorn -b 0.0.0.0:3082 -k gevent -w 8 --reload --log-level=DEBUG -t 300 run82:program\ndirectory=${BACKEND_ROOT}/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/run82.log\nautostart=true\nautorestart=true\n\n[program:web]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/nodejs/bin/node web.js\ndirectory=${WEB_ROOT}/${WEB}\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/web.log\nautostart=true\nautorestart=true\n\n[program:mongod]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/mongodb/bin/mongod -f ${INSTALL_ROOT}/mongodb/conf/mongod.conf\ndirectory=${INSTALL_ROOT}/mongodb\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nautostart=true\nautorestart=true\n\n[program:run_m]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/venv/bin/python Scheduler.py\ndirectory=${BACKEND_ROOT}/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/run_m.log\nautostart=true\nautorestart=true\n\n[program:fsu_receiver]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/venv/bin/celery -A fsu_receiver.celery worker --loglevel=info\ndirectory=${BACKEND_ROOT}/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/fsu_receiver.log\nautostart=true\nautorestart=true\n\n[program:kafka]\nuser=${SDHUSER}\ncommand=${INSTALL_ROOT}/venv/bin/celery -A tasks worker -B --loglevel=info\ndirectory=${BACKEND_ROOT}/mongo\nprocess_name=%(program_name)s\nnumprocs=1\nstopsignal=QUIT\nredirect_stderr=true\nstdout_logfile=/var/supervisor/kafka_producer.log\nautostart=true\nautorestart=true"

SUPERVISORD_SERVICE_SAMPLE="[Unit]\nDescription=Process Monitoring and Control Daemon\nAfter=rc-local.service nss-user-lookup.target\n\n[Service]\nType=forking\nExecStart=${INSTALL_ROOT}/venv/bin/supervisord -c /etc/supervisord.conf\n\n[Install]\nWantedBy=multi-user.target"

MONGOD_SAMPLE="pidfilepath = ${INSTALL_ROOT}/mongodb/mongod.pid\ndbpath = ${INSTALL_ROOT}/mongodb/data\nlogpath = ${INSTALL_ROOT}/mongodb/log/shard1.log\nlogappend = true\n\nbind_ip = 0.0.0.0\nport = 27017\n\nmaxConns = 20000"

echo "generate conf/supervisord.conf"
echo -e ${SUPERVISORD_SAMPLE} > ${SCRIPT_DIR}/conf/supervisord.conf
echo "generate conf/supervisord.service"
echo -e ${SUPERVISORD_SERVICE_SAMPLE} > ${SCRIPT_DIR}/conf/supervisord.service
echo "generate conf/mongod.conf"
echo -e ${MONGOD_SAMPLE} > ${SCRIPT_DIR}/conf/mongod.conf
