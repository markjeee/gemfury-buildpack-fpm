Gem::Specification.new do |s|
  s.name              = 'some_other_gem'
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.version           = ENV["BUILD_VERSION"] || '0.1'
  s.summary           = 'A summary of some_other_gem'
  s.homepage          = 'https://some_website.com'
  s.email             = 'hello@some_website.com'
  s.authors           = [ 'An author of some_other_gem' ]
  s.license           = 'MIT'
  s.has_rdoc          = false

  s.files             = %w(README.md) +
                        Dir.glob("bin/**/*") +
                        Dir.glob("lib/**/*")

  s.description = <<DESCRIPTION
This may be a long description of some_other_gem.
DESCRIPTION
end