require 'mongo'
require 'yaml'

class Task
  include Comparable
  def self.find (task_request)
    DataStore.instance.collection.find(task_request.to_selector).map { |doc| Task.new(doc)}
  end
  
  def self.create (task_request, http_request)
    http_request.body.rewind
    parsed = Task.parse http_request.body.read
    parsed[:when] = task_request.start
    task = Task.new(parsed)
    task.save
    task
  end
  
  def self.delete (task_request)
    DataStore.instance.collection.remove(task_request.to_selector)
  end
  
  def self.parse (task_text)
    {
      :what        => task_text.gsub(/[!#]/,''),
      :importance  => task_text.scan(/!/).reduce(0){|count, importance| count + importance.length},
      :tags        => task_text.scan(/#\w+/).map{|t| t[1..-1]}
    }
  end
  
  def initialize (doc)
    @doc = doc
  end
  
  def save
    if self.has_a? :what and self.has_a? :when
      DataStore.instance.collection.save(@doc)
    end
  end
  
  def has_a? (name)
    @doc.has_key? name
  end
  alias :has? :has_a?
  
  def priority
    self.has? :importance ? self.importance : 0
  end
  
  def to_yaml
    YAML::dump_stream({"what" => self.what, "when" => self.when, "importance" => self.importance, "tags" => self.tags})
  end
  
  def to_s
    "#{self.what} #{self.when}"
  end
  
  def <=> (other)
    self.priority <=> other.priority
  end
  
  def method_missing(name, *args)
    @doc[name] || @doc[name.to_s]
  end
end