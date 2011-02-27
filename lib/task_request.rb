# Task Request
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

  FRAMES_FMT = %r{(\d+|next|last)-(days?|weeks?|months?|years?)(-ago|-from-now)?}
  DATE_FMT = %r{\d\d/\d\d/\d\d\d\d}

  def initialize(frame, options = nil)
    self.parse_time_frame(frame.intern)
    # self.parse_options(options)
  end

  def parse_time_frame(frame)
    crack_of_day = Time.local(Time.now.year, Time.now.month, Time.now.day) 
    if TaskRequest::ALIASES.has_key? frame
      @start  = crack_of_day + TaskRequest::ALIASES[frame][0] * 24 * 60 * 60
      @stop   = crack_of_day + TaskRequest::ALIASES[frame][1] * 24 * 60 * 60
    elsif frame =~ self::DATE_FMT
      @start  = Time.strftime(frame, "%d/%m/%Y")
      @stop   = (@start + 1).to_time
      # when self::TIME_FRAMES_RE then
        # parts   = frame.split("-")
        # case parts[0]
        #   when :next then
        #     i = 1
        #   when :last then
        #     i = -1
        # @start  = parts[]
        # @stop   = parts[]
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
    {"when" => {"$gte" => @start, "$lt" => @stop}}
  end
end