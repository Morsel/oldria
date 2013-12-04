if defined?(Spork)
  Spork.trap_class_method(FactoryGirl, :find_definitions)
end
