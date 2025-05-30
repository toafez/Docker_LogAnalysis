# Filename: Dockerfile - coded in utf-8

#                LogAnalysis für Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Use the official Debian Stable Slim image as parent image
# Then install the Apache2 package.
FROM debian:stable-slim

# Update the system and install any additional packages.
RUN apt update && \
    apt upgrade -y && \
    apt install -y mc && \
    apt install -y nano && \
    apt install -y apache2

# Clean the packages and install scripts in /var/cache/apt/archives/
RUN apt clean

# Activate the CGI module
RUN a2enmod cgi

# Apache2 settings for CGI scripts
RUN echo "                        \n \
<Directory /var/www/html>         \n \
   AllowOverride None             \n \
   Options +ExecCGI               \n \
   AddHandler cgi-script .cgi .sh \n \
   Require all granted            \n \
</Directory>                      \n \
" >> /etc/apache2/apache2.conf

# Copy cgi-shell-scripts content
# https://example.com/index.cgi
COPY ./ui /var/www/html
RUN rm /var/www/html/index.html

# Create a non-root user and group to run Apache with
RUN groupadd -r app-data && \
    useradd -r -g app-data app-data

# Change ownership of directories that Apache needs to write to
RUN chown -R app-data:app-data /var/www/html

# Set permissions to cgi-shell-script content
RUN chmod -R 755 /var/www/html; \
    chmod -R 755 /var/www/html/*

# Expose the Webservice ports
EXPOSE 80

# Run apache2
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
