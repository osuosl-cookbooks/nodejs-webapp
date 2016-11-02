if defined?(ChefSpec)
  def install_nodejs_webapp(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nodejs_webapp, :install, name)
  end

  def run_nodejs_webapp(name)
    ChefSpec::Matchers::ResourceMatcher.new(:nodejs_webapp, :run, name)
  end
end
