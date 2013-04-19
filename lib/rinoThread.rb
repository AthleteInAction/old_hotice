class RinoThread
  
  
  # New Instance
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def initialize limit
    
    @threads = []
    @queue = []
    @on = true
    @limit = limit
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Store a block of code
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def queue &block
    
    @queue << block
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Run everything
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def execute
    
    StartThreads()
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Start the first(@limit) threads
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def StartThreads()
    
    @limit = @queue.count if @limit >= @queue.count
    @limit.times do |i|
      
      NewThread()
      
    end
    JoinThreads()
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Join Threads
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def JoinThreads()
    
    @threads.each do |aThread|

      if aThread.join

        NewThread() if @threads.count < @queue.count && @on

      end

    end
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Execute each thread
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def NewThread()
    
    tCount = @threads.count
    @threads << Thread.new(tCount) do |tNum|
      
      @queue[tNum].call
      
      Thread.exit
      
    end
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
end