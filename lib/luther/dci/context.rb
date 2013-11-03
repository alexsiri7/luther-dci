class Luther::DCI::Context < SimpleDelegator

  class << self
    def role name, &body
      roles[name] = Class.new(Luther::DCI::Role, &body)
      module_eval %{
        def #{name.to_s}=(data)
          assign_role(:#{name.to_s}, data)
        end
      }
    end

    def roles
      @roles ||= Hash.new
    end
  end

  alias :params :__getobj__
  def initialize(params)
    super(OpenStruct.new params)
    assign_roles
  end

  def assign_roles
    params.to_h.each do |k, v|
      assign_role k, v unless self.class.roles[k].nil?
    end
  end

  def assign_role(role, object)
    params.send "#{role}=", (self.class.roles[role].new self, object)
  end


  def self.call *params
    self.new(*params).call
  end

end
