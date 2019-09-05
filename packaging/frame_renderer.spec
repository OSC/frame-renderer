# Disable debuginfo as it causes issues with bundled gems that build libraries
%global debug_package %{nil}
%global repo_name frame-renderer
%global app_name frame-renderer
%{!?package_version: %define package_version %{major}.%{minor}.%{patch}}
%{!?package_release: %define package_release 1}
%{!?git_tag: %define git_tag v%{package_version}}
%define git_tag_minus_v %(echo %{git_tag} | sed -r 's/^v//')

Name:     ondemand-%{app_name}
Version:  %{package_version}
Release:  %{package_release}%{?dist}
Summary:  SUMMARY

Group:    System Environment/Daemons
License:  MIT
URL:      https://github.com/OSC/%{repo_name}
Source0:  https://github.com/OSC/%{repo_name}/archive/%{git_tag}.tar.gz

Requires: ondemand

# Disable automatic dependencies as it causes issues with bundled gems and
# node.js packages used in the apps
AutoReqProv: no

%description
DESCRIPTION

%prep
%setup -q -n %{repo_name}-%{git_tag_minus_v}


%build
scl enable ondemand - << \EOS
export PASSENGER_APP_ENV=production
export PASSENGER_BASE_URI=/pun/sys/%{app_name}
bin/setup
EOS

%install
%__rm        ./log/production.log
%__mkdir_p   %{buildroot}%{_localstatedir}/www/ood/apps/sys/%{app_name}
%__cp -a ./. %{buildroot}%{_localstatedir}/www/ood/apps/sys/%{app_name}/
%__mkdir_p   %{buildroot}%{_localstatedir}/www/ood/apps/sys/%{app_name}/tmp
touch        %{buildroot}%{_localstatedir}/www/ood/apps/sys/%{app_name}/tmp/restart.txt
echo v%{version} > %{buildroot}%{_localstatedir}/www/ood/apps/sys/%{app_name}/VERSION

%__mkdir_p   %{buildroot}%{_sharedstatedir}/ondemand-nginx/config/apps/sys
touch        %{buildroot}%{_sharedstatedir}/ondemand-nginx/config/apps/sys/%{app_name}.conf


%post
# Install (not upgrade)
if [ $1 -eq 1 ]; then
  # This NGINX app config needs to exist before it can be rebuilt
  touch %{_sharedstatedir}/ondemand-nginx/config/apps/sys/%{app_name}.conf

  # Rebuild NGINX app config and restart PUNs w/ no active connections
  /opt/ood/nginx_stage/sbin/update_nginx_stage &>/dev/null || :
fi


%postun
# Uninstall (not upgrade)
if [[ $1 -eq 0 ]]; then
  # On uninstallation restart PUNs w/ no active connections
  /opt/ood/nginx_stage/sbin/update_nginx_stage &>/dev/null || :
fi


%posttrans
# Restart app in case PUN wasn't restarted
touch %{_localstatedir}/www/ood/apps/sys/%{app_name}/tmp/restart.txt


%files
%defattr(-,root,root)
%{_localstatedir}/www/ood/apps/sys/%{app_name}
%{_localstatedir}/www/ood/apps/sys/%{app_name}/manifest.yml
%ghost %{_localstatedir}/www/ood/apps/sys/%{app_name}/tmp/restart.txt
%ghost %{_sharedstatedir}/ondemand-nginx/config/apps/sys/%{app_name}.conf


%changelog
* Thu Sep 04 2019 Jeff Ohrstrom <johrstrom@osc.edu> 0.1.0-1
- initial version

