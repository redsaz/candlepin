# Generated by Buildr 1.3.5, change to your liking
# Version number for this release
VERSION_NUMBER = `grep Version: candlepin.spec`.split()[1]
RELEASE_NUMBER = `grep Release: candlepin.spec | sed 's/%{?dist}//g' | awk '{print $2}'`.strip!
# Group identifier for your projects
GROUP = "candlepin"
COPYRIGHT = ""

require 'buildr/java/emma'
require 'net/http'
require 'rspec/core/rake_task'
require 'json'

#############################################################################

RESTEASY = [group('jaxrs-api',
                  'resteasy-jaxrs',
                  'resteasy-jaxb-provider',
                  'resteasy-guice',
                  'resteasy-atom-provider',
                  'resteasy-multipart-provider',
                  :under => 'org.jboss.resteasy',
                  # XXX: this version requires us to use
                  # ContentTypeHackFilter.java when updating,
                  # please check if its still needed, and remove if not.
                  :version => '2.3.1.GA'),
            'org.scannotation:scannotation:jar:1.0.2',
            'commons-httpclient:commons-httpclient:jar:3.1']

MIME4J = [group('apache-mime4j',
                :under => 'org.apache.james',
                :version => '0.6')]
JACKSON_NS = "com.fasterxml.jackson"
JACKSON_VERSION = "2.3.0"
JACKSON = ["#{JACKSON_NS}.core:jackson-annotations:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.core:jackson-core:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.core:jackson-databind:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.jaxrs:jackson-jaxrs-json-provider:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.jaxrs:jackson-jaxrs-base:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.module:jackson-module-jsonSchema:jar:#{JACKSON_VERSION}",
            "#{JACKSON_NS}.module:jackson-module-jaxb-annotations:jar:#{JACKSON_VERSION}"]
SUN_JAXB = 'com.sun.xml.bind:jaxb-impl:jar:2.1.12'
JUNIT = ['junit:junit:jar:4.5', 'org.mockito:mockito-all:jar:1.8.5']
LOGBACK = [group('logback-core', 'logback-classic', :under => 'ch.qos.logback', :version => '1.0.13')]
HIBERNATE = ['org.hibernate:hibernate-core:jar:4.2.5.Final',
             'org.hibernate.common:hibernate-commons-annotations:jar:4.0.1.Final',
             'org.hibernate:hibernate-entitymanager:jar:4.2.5.Final',
             'org.hibernate:hibernate-tools:jar:3.2.4.GA',
             # hibernate-validator required for hibernate-tools
             'org.hibernate:hibernate-validator:jar:4.3.1.Final',
             'org.hibernate:hibernate-c3p0:jar:4.2.5.Final',
             'org.hibernate.javax.persistence:hibernate-jpa-2.0-api:jar:1.0.1.Final',
             'antlr:antlr:jar:2.7.7',
             'asm:asm:jar:3.0',
             'cglib:cglib:jar:2.2',
             'javassist:javassist:jar:3.12.0.GA',
             'javax.transaction:jta:jar:1.1',
             'org.slf4j:slf4j-api:jar:1.7.5',
             'org.freemarker:freemarker:jar:2.3.15',
             'c3p0:c3p0:jar:0.9.1.2',
             'dom4j:dom4j:jar:1.6.1',
             'org.jboss.logging:jboss-logging:jar:3.1.1.GA']
DB = ['postgresql:postgresql:jar:9.0-801.jdbc4', 'mysql:mysql-connector-java:jar:5.1.26']
ORACLE = ['com.oracle:ojdbc6:jar:11.2.0', 'org.quartz-scheduler:quartz-oracle:jar:2.1.5']
COMMONS = ['commons-codec:commons-codec:jar:1.4',
           'commons-collections:commons-collections:jar:3.1',
           'commons-io:commons-io:jar:1.3.2',
           'commons-lang:commons-lang:jar:2.5']

# Artifacts that bridge other logging frameworks to slf4j. Mime4j uses
# JCL for example.
SLF4J_BRIDGES = ['org.slf4j:jcl-over-slf4j:jar:1.7.5']
HSQLDB = 'hsqldb:hsqldb:jar:1.8.0.10'
GETTEXT_COMMONS = 'org.xnap.commons:gettext-commons:jar:0.9.6'

BOUNCYCASTLE = group('bcprov-jdk16', :under=>'org.bouncycastle', :version=>'1.46')

GUICE =  [group('guice-assistedinject', 'guice-multibindings',
                'guice-servlet', 'guice-throwingproviders', 'guice-persist',
                :under=>'com.google.inject.extensions', :version=>'3.0'),
           'com.google.inject:guice:jar:3.0',
           'aopalliance:aopalliance:jar:1.0',
           'javax.inject:javax.inject:jar:1',
           'javax.servlet:servlet-api:jar:2.5']

COLLECTIONS = 'com.google.collections:google-collections:jar:1.0'

OAUTH= [group('oauth',
              'oauth-provider',
              :under => 'net.oauth.core',
              :version => '20100527')]

QUARTZ = 'org.quartz-scheduler:quartz:jar:2.1.5'

HORNETQ = [group('hornetq-server',
                 'hornetq-core-client',
                 'hornetq-commons',
                 'hornetq-journal',
#                 'hornetq-resources', #Native libs for libaio
                 :under=>'org.hornetq',
                 :version=>'2.3.5.Final'),
            'org.jboss.netty:netty:jar:3.2.1.Final']


SCHEMASPY = 'net.sourceforge:schemaSpy:jar:4.1.1'

RHINO = 'org.mozilla:rhino:jar:1.7R3'

# required by LOGDRIVER
LOG4J_BRIDGE = 'org.slf4j:log4j-over-slf4j:jar:1.7.5'
LOGDRIVER = 'logdriver:logdriver:jar:1.0'

#############################################################################
# REPOSITORIES
#
# Specify Maven 2.0 remote repositories here, like this:
repositories.remote << "http://jmrodri.fedorapeople.org/ivy/candlepin/"
repositories.remote << "http://mirrors.ibiblio.org/pub/mirrors/maven2/"
repositories.remote << "http://repository.jboss.org/nexus/content/groups/public/"
repositories.remote << "http://gettext-commons.googlecode.com/svn/maven-repository/"
repositories.remote << "http://oauth.googlecode.com/svn/code/maven/"


nocstyle = ENV['nocheckstyle']
if nocstyle.nil?
   require "./buildr/checkstyle"
end

# dont require findbugs by default
# needs "buildr-findBugs" gem installed
# (and findbugs and it's large set of deps)
findbugs = ENV['findbugs']
if not findbugs.nil?
    require 'buildr-findBugs'
end

use_pmd = ENV['pmd']
if not use_pmd.nil?
    require 'buildr/pmd'
end

use_logdriver = ENV['logdriver']
puts use_logdriver

#############################################################################
# PROJECT BUILD
#############################################################################
desc "The Proxy project"
define "candlepin" do

  #
  # project info
  #
  project.version = VERSION_NUMBER
  project.group = GROUP
  manifest["Implementation-Vendor"] = COPYRIGHT

  #
  # eclipse settings
  # http://buildr.apache.org/more_stuff.html#eclipse
  #
  eclipse.natures 'org.eclipse.jdt.core.javanature'
  eclipse.builders 'org.eclipse.jdt.core.javabuilder'

  # download the stuff we do not have in the repositories
  download artifact(SCHEMASPY) => 'http://downloads.sourceforge.net/project/schemaspy/schemaspy/SchemaSpy%204.1.1/schemaSpy_4.1.1.jar'
  download artifact(LOGDRIVER) => 'http://jmrodri.fedorapeople.org/ivy/candlepin/logdriver/logdriver/1.0/logdriver-1.0.jar' if use_logdriver

  # Resource Substitution
  resources.filter.using 'version'=>VERSION_NUMBER,
        'release'=>RELEASE_NUMBER

  if not use_pmd.nil?
      pmd.enabled = true
  end

  # Hook in gettext bundle generation to compile
  nopo = ENV['nopo']
  sources = FileList[_("po/*.po")]
  generate = file(_("target/generated-source") => sources) do |dir|
    mkdir_p dir.to_s
    sources.each do |source|
      locale = source.match("\/([^/]*)?\.po$")[1]
      #we do this inside the loop, in order to create a stub "generate" var
      if nopo.nil? || nopo.split(/,\s*/).include?(locale)
        sh "msgfmt --java -r org.candlepin.i18n.Messages -d #{dir} -l #{locale} #{source}"
      end
    end
  end
  compile.from generate

  #
  # building
  #
  compile.options.target = '1.6'
  compile.options.source = '1.6'
  compile_classpath = [COMMONS, SLF4J_BRIDGES, RESTEASY, LOGBACK, HIBERNATE, BOUNCYCASTLE,
    GUICE, JACKSON, QUARTZ, GETTEXT_COMMONS, HORNETQ, SUN_JAXB, MIME4J, OAUTH, RHINO, COLLECTIONS]
  compile.with compile_classpath
  compile.with LOGDRIVER, LOG4J_BRIDGE if use_logdriver
  if Buildr.environment == 'oracle'
    compile.with ORACLE
  else
    compile.with DB
  end

  #
  # testing
  #
  test.resources.filter.using 'version'=>VERSION_NUMBER,
        'release'=>RELEASE_NUMBER
  test.setup do |task|
    filter('src/main/resources/META-INF').into('target/classes/META-INF').run
  end

  # the other dependencies are gotten from compile.classpath automagically
  test.with HSQLDB, JUNIT, generate
  test.with LOGDRIVER, LOG4J_BRIDGE if use_logdriver
  test.using :java_args => [ '-Xmx2g', '-XX:+HeapDumpOnOutOfMemoryError' ]

  #
  # javadoc projects
  #
  doc.using :tag => 'httpcode:m:HTTP Code:'

  # NOTE: changes here must also be made in build.xml!
  candlepin_path = "org/candlepin"
  compiled_cp_path = "#{compile.target}/#{candlepin_path}"

  # The apicrawl package is only used for generating documentation so there is no
  # need to ship it.  Ideally, we'd put apicrawl in its own buildr project but I
  # kept getting complaints about circular dependencies.
  package(:jar, :id=>'candlepin-api').tap do |jar|
    jar.clean
    pkgs = %w{auth config exceptions jackson model paging pki resteasy service util}.map { |pkg| "#{compiled_cp_path}/#{pkg}" }
    p = jar.path(candlepin_path)
    p.include(pkgs).exclude("#{compiled_cp_path}/util/apicrawl")
  end

  package(:jar, :id=>"candlepin-certgen").tap do |jar|
    jar.clean
    pkgs = %w{config exceptions jackson model pinsetter pki service util}.map { |pkg| "#{compiled_cp_path}/#{pkg}" }
    p = jar.path(candlepin_path)
    p.include(pkgs).exclude("#{compiled_cp_path}/util/apicrawl")
  end

  package(:war, :id=>"candlepin").tap do |war|
    war.libs += artifacts(HSQLDB)
    war.classes.clear
    war.classes = [generate, resources.target]
    web_inf = war.path('WEB-INF/classes')
    web_inf.include("#{compile.target}/net")
    web_inf.path(candlepin_path).include("#{compiled_cp_path}/**").exclude("#{compiled_cp_path}/util/apicrawl")
  end

  desc 'Print a list of dependencies'
  task :antdeps do
    artifacts(compile_classpath).collect do |a|
      jar = File.basename(a.to_s).sub!(/(.*)-\d.*.jar/, '\1')
      puts "<include name=\"**/#{jar}-*.jar\"/>"
    end
  end

  desc "generate a .syntastic_class_path for vim/syntastic"
  task :list_classpath do
    # see https://github.com/scrooloose/syntastic/blob/master/syntax_checkers/java/javac.vim
    # this generates a .syntastic_class_path so the syntastic javac checker will
    # work properly
    syntastic_class_path = File.new(".syntastic_class_path", "w")
    syn_class_path_buf = ""
    compile.dependencies.inject("") { |a,c| syn_class_path_buf << "#{c}\n"}
    syn_class_path_buf << "#{Java.tools_jar}\n"
    # I'm sure there is a better way to figure out local target
    syn_class_path_buf << "target/classes\n"

    syntastic_class_path.write(syn_class_path_buf)
    syntastic_class_path.close()
  end

  desc 'Crawl the REST API and print a summary.'
  task :apicrawl  do
    options.test = 'no'

    # Join compile classpath with the package jar. Add the test log4j
    # to the front of the classpath:
    cp = ['src/test/resources'] | [project('candlepin').package(:jar)] | compile_classpath
    Java::Commands.java('org.candlepin.util.apicrawl.ApiCrawler',
                        {:classpath => cp})

    classes = artifacts(cp).collect do |a|
      task(a.to_s).invoke
      File.expand_path a.to_s
    end

    # Just run the doclet on the *Resource files
    sources = project('candlepin').compile.sources.collect do |dir|
      Dir["#{dir}/**/*Resource.java"]
    end.flatten

    # Add in the options as the last arg
    sources << {:name => 'Candlepin API',
                :classpath => classes,
                :doclet => 'org.candlepin.util.apicrawl.ApiDoclet',
                :docletpath => ['target/classes', classes].flatten.join(File::PATH_SEPARATOR),
                :output => 'target'}

    Java::Commands.javadoc(*sources)

    api_file = 'target/candlepin_api.json'
    comments_file = 'target/candlepin_comments.json'
    api = JSON.parse(File.read(api_file))
    comments = JSON.parse(File.read(comments_file))

    combined = Hash[api.collect { |a| [a['method'], a] }]
    comments.each do |c|
      if combined.has_key? c['method']
        combined[c['method']].merge!(c)
      else
        combined[c['method']] = c
      end
    end

    final = JSON.dump(combined.values.sort_by { |v| v['method'] })
    final_file = 'target/candlepin_methods.json'
    File.open(final_file, 'w') { |f| f.write final }

    # Cleanup
    rm api_file
    rm comments_file
    puts
    puts "Wrote Candlepin API to: " << final_file
    puts

  end

  desc 'Generate HTML API Documentation'
  task :apidoc  => [:apicrawl] do
    options.test = 'no'
    sh('apidoc/apidoc.rb target/candlepin_methods.json')
  end

  desc 'Lint the REST API documentation'
  task :apilint  => [:apicrawl] do
    options.test = 'no'
    sh('apidoc/lint.rb target/candlepin_methods.json')
  end

  desc 'Copy the API Docs to the website directory'
  task :apicopy  => [:apidoc] do
    options.test = 'no'
    sh('cp -R target/apidoc website/')
  end

  desc 'run rpmlint on the spec file'
  task :rpmlint do
      sh('rpmlint -f rpmlint.config candlepin.spec')
  end

  #
  # coverity report generation
  #
  desc 'Generate coverity reports (coverity must be installed)'
  task :coverity => [:compile] do
    mkdir_p compile.target.to_s
    sources = FileList[_("src/main/java/**/*.java")]
    classpath = compile.dependencies.inject("") {|a,c| a << ":#{c}"}
    classpath << ":#{Java.tools_jar}"

    sh "cov-build --dir=/cov_builds/candlepin_jd/ javac -classpath #{classpath} -d #{compile.target} -verbose -g -target 1.6 #{sources}"
    sh "cov-analyze-java --dir=/cov_builds/candlepin_jd/"
    sh "cov-commit-defects --dir /cov_builds/candlepin_jd/ --stream candlepin --user admin --host #{`hostname`}"
  end

  #
  # to use: buildr candlepin:genschema
  #
  task :genschema do
    begin
      ant('gen-schema') do |ant|
        rm_rf 'target/schema'
        mkdir_p 'target/schema'
        filter('src/main/resources/META-INF').into('target/classes/META-INF').run

        ant.taskdef :name=>'schema',
          :classname=>'org.hibernate.tool.ant.HibernateToolTask',
          #:classpath=>Buildr.artifacts([HIBERNATE, HSQLDB, DB, COMMONS, LOGBACK, RESTEASY, JACKSON, QUARTZ]).each(&:invoke).map(&:name).join(File::PATH_SEPARATOR)
          :classpath=>Buildr.artifacts([HIBERNATE, COMMONS, LOGBACK, QUARTZ]).each(&:invoke).map(&:name).join(File::PATH_SEPARATOR)

        ant.schema :destdir=>'target/schema' do
          ant.classpath :path=>_('target/classes')
          ant.jpaconfiguration :persistenceunit=>'production'
          ant.hbm2ddl :export=>'false', :update=>'false', :drop=>'false', :create=>'true',
            :outputfilename=>'candlepin-proxy.sql', :delimiter=>';', :format=>'true', :haltonerror=>'true'
        end
      end
    ensure
      rm_rf 'target/classes/META-INF'
    end
    # copy over the quartz schema files
    cp_r 'code/schema/quartz/', 'target/schema/quartz'
  end

  desc 'Create an html report of the schema'
  task :schemaspy do
   cp = Buildr.artifacts(DB, SCHEMASPY).each(&:invoke).map(&:name).join(File::PATH_SEPARATOR)
   puts cp
   command = "-t pgsql -db candlepin -s public -host localhost -u candlepin -p candlepin -o target/schemaspy"
   ant('java') do |ant|
     ant.java(:classname => "net.sourceforge.schemaspy.Main", :classpath => cp, :fork => true) do |java|
       command.split(/\s+/).each {|value| ant.arg :value => value}
     end
   end
  end

end

# runs the eclipse task to generate the .classpath and .project
# files, then fixes the output.
task :eclipse do
  puts "Fixing eclipse .classpath"
  text = File.read(".classpath")
  tmp = File.new("tmp", "w")
  text = text.gsub(/output="target\/resources"/, "")
  tmp.write(text.gsub(/<\/classpath>/, "  <classpathentry path=\"#{Java.tools_jar}\" kind=\"lib\"\/>"))
  tmp.write("</classpath>")
  tmp.close()
  FileUtils.copy("tmp", ".classpath")
  File.delete("tmp")

  # make the gettext output dir to silence eclipse errors
  mkdir_p("target/generated-source")
end

namespace "gettext" do
    task :extract do
      %x{xgettext -ktrc:1c,2 -k -ktrnc:1c,2,3 -ktr -kmarktr -ktrn:1,2 -o po/keys.pot $(find src/main/java -name "*.java")}
    end
    task :merge do
      sources = FileList["po/*.po"]
      sources.each do |source|
        sh "msgmerge -N --backup=none -U #{source} po/keys.pot"
      end
    end
end

desc 'Make sure eventhing is working as it should'
task :check_all => [:clean, :checkstyle, 'candlepin:rpmlint', :test, :deploy, :spec]

#==========================================================================
# Tomcat deployment
#==========================================================================
desc 'Build and deploy candlepin to a local Tomcat instance'
task :deploy do
  `buildconf/scripts/deploy`
end

task :deploy_check do
  begin
    http = Net::HTTP.new('localhost', 8443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start do |http|
      response = http.request Net::HTTP::Get.new "/candlepin/admin/init"
      Rake::Task[:deploy].invoke if response.code != '200'
    end
  rescue
    # Http request failed
    Rake::Task[:deploy].invoke
  end
end

#==========================================================================
# RSpec functional tests
#==========================================================================
RSpec::Core::RakeTask.new do |task|

  # Support optional features env variable, specify the spec files to run
  # without the trailing '_spec.rb'. Specify multiple by separating with ':'.
  # i.e. build spec features=flex_expiry:authorization
  features = ENV['features']
  if not features.nil?
    feature_files = Array.new
    features.split(":").each do |part|
      feature_files << "spec/#{part}_spec.rb"
    end
    task.pattern = feature_files
  end

  task.rspec_opts = ["-I#{File.expand_path 'client/ruby/'}"]
  task.rspec_opts << '-c'
  skipbundler = ENV['skipbundler']
  if not skipbundler.nil?
      task.skip_bundler = true
  end

  # Allow specify only="should do something" to run only a specific
  # test. The text must completely match the contents of your "it" string.
  only_run = ENV['only']
  if not only_run.nil?
    task.rspec_opts << "-e '#{only_run}'"
  end

  fail_fast = ENV['fail_fast']
  if not fail_fast.nil?
    task.rspec_opts << "--fail-fast"
  end

  dots = ENV['dots']
  if not dots.nil?
    task.rspec_opts << "-fp"
  else
    task.rspec_opts << "-fd"
  end
end
#task :spec => :deploy_check

# fix the coverage reports generated by emma.
# we're adding to the existing emma:html task here
# This is AWESOME!
namespace :emma do
   task :html do
      puts "Fixing emma reports"
      fixemmareports("reports/emma/coverage.html")

      dir = "reports/emma/_files"
      Dir.foreach(dir) do |filename|
          fixemmareports("#{dir}/#{filename}") unless filename == "." || filename == ".."
      end
   end
end

# fixes the html produced by emma
def fixemmareports(filetofix)
      text = File.read(filetofix)
      newstr = ''
      text.each_byte do |c|
         if c != 160 then
             newstr.concat(c)
         else
             newstr.concat('&nbsp;')
         end
      end
      tmp = File.new("tmpreport", "w")
      tmp.write(newstr)
      tmp.close()
      FileUtils.copy("tmpreport", filetofix)
      File.delete("tmpreport")
end
