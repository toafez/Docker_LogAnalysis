#!/bin/bash
# Filename: html_functions.sh - coded in utf-8

#                    Logfile Analysis
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Popupbox Ausgabe
# --------------------------------------------------------------
function popupbox () {
	echo '
	<div class="container">
		<div class="row">
			<div class="col">
			</div>
			<div class="col">
				<p>&nbsp;</p><p>&nbsp;</p>
				<div class="card" style="width: '${1}'rem;">
					<div class="card-header text-secondary">'${2}'</div>
					<div class="card-body">
						<p class="card-text text-center text-secondary">'${3}'</p>
						<p class="card-text text-center text-secondary">'${4}'</p>
					</div>
				</div>
			</div>
			<div class="col">
			</div>
			<!-- col -->
		</div>
		<!-- row -->
	</div>
	<!-- container -->'
	exit
}
