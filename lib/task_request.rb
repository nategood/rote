# Task Request
# Used to query our Task dataset
# Commonly created from a URI
class TaskRequest
  attr_accessor :start, :stop, :importance, :tags, :status

  Infinity = 99999 #Infinity = 1.0/0

  ALIASES = {
    :today      => [0, 1],
    :yesterday  => [-1, 0],
    :tomorrow   => [1, 2],
    :past       => [-Infinity, 0],
    :future     => [0, Infinity]
  }

  STATES = {
    :unfinished => 1,
    :done       => 2
    # :started    => 3,
  }

  FramesFmt = /(\d+|next|last)-(day|week|month|year)s?-(ago|from-now)?/
  DateFmt = /\d\d-\d\d-\d\d\d\d/

  def initialize(frame, options = nil)
    self.parse_time_frame(frame.intern)
    # self.parse_options(options)
  end

  def parse_time_frame(frame)
    crack_of_day = Time.local(Time.now.year, Time.now.month, Time.now.day) 
    if TaskRequest::ALIASES.has_key? frame
      @start  = crack_of_day + TaskRequest::ALIASES[frame][0] * 24 * 60 * 60
      @stop   = crack_of_day + TaskRequest::ALIASES[frame][1] * 24 * 60 * 60
    elsif frame =~ self::DateFmt
      @start  = Time.strftime(frame, "%m-%d-%Y")
      @stop   = (@start + 1).to_time
    elsif frame =~ self::FramesFmt
      parts = frame.scan(self::FramesFmt)
      if parts && parts.length >= 2
        scalar = parts[0] # TODO if non numeric convert next into "+1" and last into "-1"
        interval = parts[1] 
        scalar *= -1 if parts.length == 3 && parts[2].intern == :ago
        # TODO 
        # @start  = parts[]
        # @stop   = parts[]
      end
    end    
  end
  # def parse_options(options)
  #   options.split('/').each do |i| 
  #     if i =~ %r{^!+$}
  #       @importance = i.length
  #     # elsif self.STATES.has_key? i
  #   end
  # end
  
  # Get Mongo "selector" clause for this request
  def to_selector()
    # TODO expand for importance and tag filters
    {:when => {"$gte" => @start, "$lt" => @stop}}
  end
end