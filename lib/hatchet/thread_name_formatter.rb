# -*- encoding: utf-8 -*-

module Hatchet

  # Internal: Module for standardizing the formatting of thread contexts.
  #
  module ThreadNameFormatter

    private

    # Private: Returns the name of the current thread from the processes pid and
    # the threads object_id when it is not the main thread for the process.
    #
    def thread_name
      if Thread.current == Thread.main
        Process.pid
      else
        "#{Process.pid}##{Thread.current.object_id}"
      end
    end

  end

end

