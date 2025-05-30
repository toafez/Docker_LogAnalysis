#!/bin/bash
# Filename: settings.sh - coded in utf-8

#                LogAnalysis für Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Load horizontal navigation bar
# --------------------------------------------------------------
mainnav

# Show homepage
# --------------------------------------------------------------
if [[ "${GETpage}" == "settings" && "${GETsection}" == "start" ]]; then


	# Folder settings
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<h4>'${txt_link_settings}'</h4><br />
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_folder_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# Folder attributes on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_folder_attributes}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=folder_attributes&'; \
												if [[ "${folder_attributes}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
									<tr>'
										# Folder without access on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_folder_access}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=folder_access&'; \
												if [[ "${folder_access}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'

	# File settings
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_file_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# File attributes on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_file_attributes}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=file_attributes&'; \
												if [[ "${file_attributes}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
									<tr>'
										# File access on/off
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_file_access}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=file_access&'; \
												if [[ "${file_access}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'

	# Debug
	# --------------------------------------------------------------
	echo '
	<div class="row mt-2">
		<div class="col pr-1">
			<div class="card border-0">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txt_debug_title}'</strong></span>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-borderless table-hover table-sm">
								<thead></thead>
								<tbody>
									<tr>'
										# Debugging
										echo -n '
										<td scope="row" class="row-sm-auto align-middle">
											'${txt_debug_mode_on}'
										</td>
										<td class="text-end">'
											echo -n '
											<a href="index.cgi?page=settings&section=save&option=debugging&'; \
												if [[ "${debugging}" == "on" ]]; then
													echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
												else
													echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
												fi
												echo -n '
											</a>
										</td>
									</tr>
								</tbody>
							</table>'
							if [[ "${debugging}" == "on" ]]; then
								echo '
								<table class="table table-borderless table-hover table-sm">
									<thead></thead>
										<tbody>
											<tr>'
												# GET & POST requests
												echo -n '
												<td scope="row" class="row-sm-auto align-middle">
													'${txt_debug_requests}'
												</td>
												<td class="text-end">'
													echo -n '
													<a href="index.cgi?page=settings&section=save&option=http_requests&'; \
														if [[ "${http_requests}" == "on" ]]; then
															echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
														else
															echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
														fi
														echo -n '
													</a>
												</td>
											</tr>
											<tr>'
												# GET & POST requests
												echo -n '
												<td scope="row" class="row-sm-auto align-middle">
													'${txt_debug_global}'
												</td>
												<td class="text-end">'
													echo -n '
													<a href="index.cgi?page=settings&section=save&option=global_enviroment&'; \
														if [[ "${global_enviroment}" == "on" ]]; then
															echo -n 'query=off" class="link-primary"><i class="bi bi-toggle-on" style="font-size: 2rem;"></i>'
														else
															echo -n 'query=on" class="link-secondary"><i class="bi bi-toggle-off" style="font-size: 2rem;"></i>'
														fi
														echo -n '
													</a>
												</td>
											</tr>
										</tbody>
									</table>'
							#elif [[ "${debugging}" == "off" ]]; then
							#	[ -f "${system_config}" ] && rm "${system_config}"
							#		echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=settings&section=start">'
							fi
							echo '
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>'
fi

# Debug - Execution
# --------------------------------------------------------------
if [[ "${GETpage}" == "settings" && "${GETsection}" == "save" ]]; then
	[ -f "${get_request}" ] && rm "${get_request}"

	# Save the settings to ${app_home_dir}/settings/user_settings.txt
	[[ "${GEToption}" == "folder_attributes" ]] && setkeyvalue "folder_attributes" "${GETquery}" "${system_config}"
	[[ "${GEToption}" == "folder_access" ]] && setkeyvalue "folder_access" "${GETquery}" "${system_config}"

	[[ "${GEToption}" == "file_attributes" ]] && setkeyvalue "file_attributes" "${GETquery}" "${system_config}"
	[[ "${GEToption}" == "file_access" ]] && setkeyvalue "file_access" "${GETquery}" "${system_config}"

	[[ "${GEToption}" == "debugging" ]] && setkeyvalue "debugging" "${GETquery}" "${system_config}"
	[[ "${GEToption}" == "http_requests" ]] && setkeyvalue "http_requests" "${GETquery}" "${system_config}"
	[[ "${GEToption}" == "global_enviroment" ]] && setkeyvalue "global_enviroment" "${GETquery}" "${system_config}"
	echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=settings&section=start">'
fi
