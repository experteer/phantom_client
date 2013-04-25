module PhantomJSProxy
  class PhantomError < Exception
  end
  class NoProxy < PhantomError
  end
  class ProxyErrorLoadingPage < PhantomError
  end
end
