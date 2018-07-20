# frozen_string_literal: true

# Cloud Foundry Java Buildpack
# Copyright 2013-2018 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'java_buildpack/component/versioned_dependency_component'

module JavaBuildpack
  module Container

    # Encapsulates the detect, compile, and release functionality for Tomcat logging support.
    class TomcatLoggingSupport < JavaBuildpack::Component::VersionedDependencyComponent

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        download_jar(jar_name, bin)
        write_set_env
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release; end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        true
      end

      private

      def bin
        @droplet.sandbox + 'bin'
      end

      def jar_name
        "tomcat_logging_support-#{@version}.jar"
      end

      def setenv
        bin + 'setenv.sh'
      end

      def write_set_env
        setenv.open('w') do |f|
          f.write <<~SH
            #!/bin/sh

            CLASSPATH=$CLASSPATH:#{(bin + jar_name).relative_path_from(@droplet.root)}
          SH
        end
      end

    end

  end
end
