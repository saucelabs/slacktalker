source ~/venv/bin/activate
pkill uwsgi
uwsgi -s /tmp/uwsgi.sock --module webapp --callable app --chmod-socket=666 >> /tmp/webapp.log 2>&1 &
