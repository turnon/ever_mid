require "middleman-core"

Middleman::Extensions.register :ever_mid do
  require "my-extension/extension"
  MyExtension
end
