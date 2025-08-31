FROM frappe/bench:latest

WORKDIR /home/frappe/frappe-bench

# Clone HRMS app into apps directory (instead of bench get-app at build time)
RUN git clone https://github.com/frappe/hrms apps/hrms

# Expose port
EXPOSE 8000

# At container startup:
# 1. Create site if it doesn't exist
# 2. Install HRMS
# 3. Start Frappe
CMD bash -c " \
    if [ ! -d sites/${SITE_NAME} ]; then \
        bench new-site ${SITE_NAME} \
            --mariadb-root-password=${MYSQLPASSWORD} \
            --admin-password=${ADMIN_PASSWORD} \
            --db-host=${MYSQLHOST} \
            --db-port=${MYSQLPORT} \
            --db-user=${MYSQLUSER} \
            --db-password=${MYSQLPASSWORD} && \
        bench --site ${SITE_NAME} install-app hrms; \
    fi && \
    bench start"
