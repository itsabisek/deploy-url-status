# Intialize log file
touch /tmp/bootstrap.log

# Save a variable for the app path
LOG_FILE=/tmp/bootstrap.log
APP_PATH=/var/www/html/app
ENV_PATH=$APP_PATH/env
PIP_PATH=$ENV_PATH/bin/pip
NGINX_PATH_AVAILABLE=/etc/nginx/sites-available
NGINX_PATH_ENABLED=/etc/nginx/sites-enabled
SYSTEMD_PATH=/etc/systemd/system

# Install python, virtualenv and git
echo "Installing python git venv and nginx" >> $LOG_FILE
apt-get update
apt-get install -yq git python3.8 virtualenv nginx
echo "Successfully installed python git venv and nginx" >> $LOG_FILE

# Fetch git repo and setup branch
echo "Cloning git repository to $APP_PATH" >> $LOG_FILE
git clone https://github.com/itsabisek/url-status.git $APP_PATH
echo "Cloned source repo to $APP_PATH" >> $LOG_FILE

# Create new virtualenv
echo "Creating new virtual environment" >> $LOG_FILE
mkdir -p $ENV_PATH
virtualenv -p $(which python3.8) $ENV_PATH
echo "Created virtual env with $($ENV_PATH/bin/python --version)" >> $LOG_FILE

# Upgrade pip and install requirements
echo "Installing modules from requirements" >> $LOG_FILE
$PIP_PATH install -U pip
$PIP_PATH install -r /var/www/html/app/requirements.txt
echo "Installed all requirements - $($PIP_PATH freeze)" >> $LOG_FILE

# Install node and npm to run react
echo "Installing nodejs and npm" >> $LOG_FILE
cd /tmp && curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
apt install -yq nodejs
echo "Successfully installed nodejs - $(nodejs --version) and npm $(npm --version)" >> $LOG_FILE

# Touch the log file
echo "Creating log file for application" >> $LOG_FILE
mkdir /var/log/urlstatus && touch /var/log/urlstatus/error.log

# Install required node modules
echo "Installing node modules" >> $LOG_FILE
cd $APP_PATH && npm install
echo "Installed all node modules" >> $LOG_FILE

# Copy nginx conf and restart nginx
echo "Setting up nginx" >> $LOG_FILE
rm -f $NGINX_PATH_AVAILABLE/default $NGINX_PATH_ENABLED/default
cp $APP_PATH/conf/nginx/harvester $NGINX_PATH_AVAILABLE
ln -s $NGINX_PATH_AVAILABLE/harvester $NGINX_PATH_ENABLED/harvester
echo "Created nginx configuration" >> $LOG_FILE

# Copy systemd file and start the api server
echo "Creating api server service" >> $LOG_FILE
cp $APP_PATH/conf/systemd/urlstatus.service $SYSTEMD_PATH/
echo "Create configuration for api server service" >> $LOG_FILE

# Start all service
echo "Starting all required services" >> $LOG_FILE
npm run build
echo "Created production build" >> $LOG_FILE
service nginx restart
echo "Started nginx web server" >> $LOG_FILE
systemctl daemon-reload
systemctl enable url-status.service
systemctl start url-status.service
echo "Started api server" >> $LOG_FILE

echo "Bootstrapping complete!!" >> $LOG_FILE