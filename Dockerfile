# Start from the official frappe bench image
FROM frappe/bench:latest

# Environment variables
ENV SITE_NAME=hrms.prod
ENV ADMIN_PASSWORD=password123!@#

WORKDIR /home/frappe/frappe-bench

# Get HRMS app
RUN bench get-app hrms https://github.com/frappe/hrms

# Create site (DB & Redis details will come from Railway plugins)
RUN bench new-site $SITE_NAME \
    --mariadb-root-password=$MYSQLPASSWORD \
    --admin-password=$ADMIN_PASSWORD \
    --db-host=$MYSQLHOST \
    --db-port=$MYSQLPORT \
    --db-user=$MYSQLUSER \
    --db-password=$MYSQLPASSWORD

# Install HRMS app
RUN bench --site $SITE_NAME install-app hrms

# Expose port
EXPOSE 8000

# Start Frappe
CMD ["bench", "start"]
