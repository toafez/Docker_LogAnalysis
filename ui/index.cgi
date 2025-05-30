#!/bin/bash
# Filename: index.cgi - coded in utf-8

#                LogAnalysis für Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License

# Set environment variables
# --------------------------------------------------------------

	app_home_dir="/var/www/html"
	app_tmp_dir="/tmp"
	app_logfile_dir="/tmp/log"

	# Set up temporary environment
	# ----------------------------------------------------------

	# Create files for temporary GET/POST requests.
	get_request="${app_tmp_dir}/get_request"
	[ ! -f "${get_request}" ] && install -m 777 /dev/null "${get_request}"
	post_request="${app_tmp_dir}/post_request"
	[ ! -f "${post_request}" ] && install -m 777 /dev/null "${post_request}"

	# Create file for temporary search result.
	search_result="${app_tmp_dir}/search_result.txt"
	[ ! -f "${search_result}" ] && install -m 777 /dev/null "${search_result}"

	# Create file for persitent system configuration.
	system_config="${app_tmp_dir}/system_config.txt"
	[ ! -f "${system_config}" ] && install -m 777 /dev/null "${system_config}"
	[ -f "${system_config}" ] && source "${system_config}"

	# Set up start page
	# ----------------------------------------------------------

	# If no page is set, display the start page.
	if [ -z "${GETpage}" ]; then
		echo "GETpage=\"main\"" > "${get_request}"
		echo "GETsection=\"start\"" >> "${get_request}"
		echo -n "" > "${post_request}"
	fi

# Processing GET/POST request variables
# --------------------------------------------------------------
	# Load urlencode and urldecode function from ../modules/parse_url.sh
	[ -f "${app_home_dir}/modules/parse_url.sh" ] && source "${app_home_dir}/modules/parse_url.sh" || exit

	# Get the Correct Content-Length for a POST Request
	[ -z "${POST_STRING}" -a "${REQUEST_METHOD}" = "POST" -a ! -z "${CONTENT_LENGTH}" ] && read -n ${CONTENT_LENGTH} POST_STRING

	# Ensure that the internal field separator (IFS) is used to separate GET/POST key/value requests, using the separator &
	if [ -z "${backupIFS}" ]; then
		backupIFS="${IFS}"
		IFS='=&'
		GET_vars=(${QUERY_STRING})
		POST_vars=(${POST_STRING})
		readonly backupIFS
		IFS="${backupIFS}"
	fi

	# Function for recording key/value requests 
	# Call: setkeyvalue "${key}" "${value}" "${request}"
	setkeyvalue()
	{
		key="${1}"
		value="${2}"
		file="${3}"

		# Check if the key/value pair has already been saved.
		if ! grep -F "${key}" "${file}" > /dev/null; then
			# If not, create a new key/value pair.
			echo "${key}=\"${value}\"" >> "${file}"
		else
			# If so, update the existing key/value pair.
			sed -i -E "s/${key}=.*/${key}=\"${value}\"/g" "${file}"
		fi
	}

	# Process incoming GET requests for GETkey="value" variables
	declare -A get
	for ((i=0; i<${#GET_vars[@]}; i+=2)); do
		GET_key=GET${GET_vars[i]}
		GET_value=${GET_vars[i+1]}
		#GET_value=$(urldecode ${GET_vars[i+1]})

		setkeyvalue "${GET_key}" "${GET_value}" "${get_request}"
	done

	# Process incoming POST requests for POSTkey="value" variables
	declare -A post
	for ((i=0; i<${#POST_vars[@]}; i+=2)); do
		POST_key=POST${POST_vars[i]}
		#POST_value=${POST_vars[i+1]}
		POST_value=$(urldecode ${POST_vars[i+1]})

		setkeyvalue "${POST_key}" "${POST_value}" "${post_request}"
	done

	# Integration of saved GET and POST requests.
	[ -f "${get_request}" ] && source "${get_request}"
	[ -f "${post_request}" ] && source "${post_request}"

	# Load language settings 
	[ -z "${language}" ] && language="ger"
	[[ "${language}" == "ger" ]] && source "${app_home_dir}/languages/lang_gui_ger.txt"
	[[ "${language}" == "enu" ]] && source "${app_home_dir}/languages/lang_gui_enu.txt"

	# Load website functions from ../assets/html/html_function.sh
	[ -f "${app_home_dir}/assets/html/html_functions.sh" ] && source "${app_home_dir}/assets/html/html_functions.sh"


# Page content
# --------------------------------------------------------------
	echo "Content-type: text/html"
	echo
	echo '
	<!doctype html>
	<html lang="en">
		<head>
			<meta charset="utf-8" />
			<title>'${app_title}'</title>
			<link rel="shortcut icon" href="images/logo_32.png" type="image/x-icon" />
			<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

			<!-- Einbinden eigener CSS Formatierungen -->
			<link rel="stylesheet" href="assets/css/stylesheet.css" />

			<!-- Integrating bootstrap framework 5.3.6 -->
			<link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css" />

			<!-- Integrating bootstrap Icons 1.13.1 -->
			<link rel="stylesheet" href="assets/bootstrap/icons/bootstrap-icons.css" />

			<!-- Integrating jQuery 3.7.1 -->
			<script src="assets/jquery/jquery-3.7.1.min.js"></script>
		</head>
		<body>
			<header></header>
			<article>
				<!-- container -->
				<div class="container-fluid">
					<form action="index.cgi" method="post" id="myform" autocomplete="on">'

						# Function: Show main navigation
						function mainnav()
						{
							echo '
							<nav class="navbar fixed-top navbar-expand-sm navbar-light bg-light">
								<div class="container-fluid">
									<a class="btn btn-sm text-dark text-decoration-none py-0" role="button" style="background-color: #e6e6e6;" href="index.cgi?page=main&section=reset" title="'${txt_button_refresh}'">
										<i class="bi bi-house-door text-dark" style="font-size: 1.2rem;"></i>
									</a>
									<div class="float-end">
										<ul class="navbar-nav">
											<li class="nav-item pt-1">'
												echo -n '
												<a class="btn btn-sm text-decoration-none" aria-current="page" href="index.cgi?page=main&section=save&option=language&'; \
													if [[ "${language}" == "ger" ]]; then
														echo -n 'query="" style="color: #28a745; background-color: #e6e6e6;">DE</i>'
													else
														echo -n 'query=ger" style="color: #343a40; background-color: #e6e6e6;">DE</i>'
													fi
													echo -n '
												</a>'
												echo '
											</li>&nbsp;&nbsp;
											<li class="nav-item pt-1">'
												echo -n '
												<a class="btn btn-sm text-decoration-none" aria-current="page" href="index.cgi?page=main&section=save&option=language&'; \
													if [[ "${language}" == "enu" ]]; then
														echo -n 'query=" style="color: #28a745; background-color: #e6e6e6;">EN</i>'
													else
														echo -n 'query=enu" style="color: #343a40; background-color: #e6e6e6;">EN</i>'
													fi
													echo -n '
												</a>'
												echo '
											</li>&nbsp;&nbsp;
											<li class="nav-item dropdown pt-1">
												<a class="dropdown-toggle btn btn-sm text-dark text-decoration-none" style="background-color: #e6e6e6;" href="#" id="navDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
													'${txt_link_system_settings}'
												</a>
												<ul class="dropdown-menu dropdown-menu-sm-end" aria-labelledby="navDropdown">
													<li><a class="dropdown-item" href="index.cgi?page=settings&section=start">'${txt_link_settings}'</a></li>
												</ul>
											</li>
										</ul>
									</div>
								</div>
							</nav>
							<p>&nbsp;</p>
							<br />'
						}

						# Evaluation of the dynamic page output
						if [ -f "${POSTpage}.sh" ]; then
							. ./"${POSTpage}.sh"
						elif [ -f "${GETpage}.sh" ]; then
							. ./"${GETpage}.sh"
						else
							echo 'Page '${GETpage}''${POSTpage}'.sh not found!'
						fi

						# Debugging
						if [[ "${debugging}" == "on" ]]; then
							echo '
							<p>&nbsp;</p>
							<div class="card border-0 mb-3">
								<div class="card-header border-0">
									<i class="bi-icon bi-bug text-secondary float-start" style="cursor: help;" title="Debug"></i>
									<span class="text-secondary">&nbsp;&nbsp;<b>Debug</b></span>
								</div>
								<div class="card-body pb-0">'
									if [ -z "${group_membership}" ] && [ -z "${http_requests}" ] && [ -z "${global_enviroment}" ]; then
										echo "<p>Bitte wählen Sie eine oder mehrere Debug Optionen aus der Liste aus!</p>"
									fi

									# GET and POST Requests
									if [[ "${http_requests}" == "on" ]]; then
										echo '
										<ul class="list-unstyled">
											<li class="text-dark list-style-square"><strong>'${txt_debug_get}'</strong>
												<ul class="list-unstyled ps-3">
													<pre>'; cat ${get_request}; echo '</pre>
												</ul>
											</li>
											<li class="text-dark list-style-square"><strong>'${txt_debug_post}'</strong>
												<ul class="list-unstyled ps-3">
													<pre>'; cat ${post_request}; echo '</pre>
												</ul>
											</li>
										</ul>'
									fi

									# Global Enviroment
									if [[ "${global_enviroment}" == "on" ]]; then
										echo '
										<ul class="list-unstyled">
											<li class="text-dark list-style-square"><strong>'${txt_debug_global}'</strong>
												<ul class="list-unstyled ps-3">
													<pre>'; (set -o posix ; set | sed '/txt.*/d;'); echo '</pre>
												</ul>
											</li>
										</ul>'
									fi
									echo '
								</div>
								<!-- card-body -->
							</div>
							<!-- card -->'
						fi
						echo '
					</form>
				</div>
				<!-- container -->
			</article>'

			if [[ "${GETpage}" == "main" && "${GETsection}" == "save" ]]; then
				[ -f "${get_request}" ] && rm "${get_request}"

				# Save the settings to ${app_home_dir}/settings/user_settings.txt
				[[ "${GEToption}" == "language" ]] && setkeyvalue "language" "${GETquery}" "${system_config}"
				echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=main&section=start">'
			fi

			echo '
			<!-- Integrating bootstrap JavaScript 5.3.6 -->
			<script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>

			<!-- Script for pop-up windows (e.g. for help) -->
			<script src="assets/js/popup.js"></script>

			<!-- Show or hide charging indicator -->
			<script src="assets/js/loading.js"></script>

		</body>
	</html>'
