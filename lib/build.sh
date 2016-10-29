install_bower_deps() {
  cd $phoenix_dir
  local bower_json=bower.json

  if [ -f $bower_json ]; then
    info "Installing and caching bower components"

    if [ -d $cache_dir/bower_components ]; then
      mkdir -p bower_components
      cp -r $cache_dir/bower_components/* bower_components/
    fi
    bower install
    cp -r bower_components $cache_dir
  fi
}

compile() {
  cd $phoenix_dir
  PATH=$build_dir/.platform_tools/erlang/bin:$PATH
  PATH=$build_dir/.platform_tools/elixir/bin:$PATH

  run_compile
}

run_compile() {
  local custom_compile="${build_dir}/${compile}"

  if [ -f $custom_compile ]; then
    info "Running custom compile"
    source $custom_compile 2>&1 | indent
  else
    info "Running default compile"
    source ${build_pack_dir}/${compile} 2>&1 | indent
  fi
}

write_profile() {
  info "Creating runtime environment"
  mkdir -p $build_dir/.profile.d
  local export_line="export MIX_ENV=${MIX_ENV}"
  echo $export_line >> $build_dir/.profile.d/phoenix_static_buildpack_paths.sh
}
