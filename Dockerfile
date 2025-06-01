# Filename: Dockerfile - coded in utf-8

#                LogAnalysis for Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Dockerfile for Debian Stable Slim with Apache and CGI shell script support 
FROM debian:stable-slim

# Maintainer
LABEL maintainer="toafez (Tommes)"

# Update the system and install any additional packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Install Midnight Commander
    mc \
    # Install nano Text Editor
    nano \
    # Install Apache Webserver
    apache2  \
    # Clean packages and install scripts in /var/cache/apt/archives/
    && apt clean \
    # Activate the CGI module
    && a2enmod cgi

# Apache2 settings for CGI scripts
RUN echo "                        \n \
<Directory /var/www/html>         \n \
   AllowOverride None             \n \
   Options +ExecCGI               \n \
   AddHandler cgi-script .cgi .sh \n \
   Require all granted            \n \
</Directory>                      \n \
" >> /etc/apache2/apache2.conf

# Copy website content
COPY ./ui /var/www/html

# Changing the ownership of the web directory to www-data
RUN chown -R www-data:www-data /var/www/html; \
    # Set permissions for CGI shell scripts
    chmod -R 755 /var/www/html; \
    chmod -R 755 /var/www/html/*; \
    # Delete the default index.html file so that the index.cgi file can be executed.
    rm /var/www/html/index.html

# Expose the Webservice ports
EXPOSE 80

# Run apache2
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

