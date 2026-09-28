# Stub implementation of rcurses for systems without the full gem
# This provides basic functionality for AMAR Tools
class String
  def fg(color)
    "\e[38;5;#{color}m#{self}\e[0m"
  end

  def bg(color)
    "\e[48;5;#{color}m#{self}\e[0m"
  end

  def b
    "\e[1m#{self}\e[0m"
  end

  def u
    "\e[4m#{self}\e[0m"
  end

  def i
    "\e[3m#{self}\e[0m"
  end

  # rcurses 7.0 names
  alias_method :bd, :b
  alias_method :it, :i
  alias_method :ul, :u

  def rv
    "\e[7m#{self}\e[0m"
  end

  def pure
    self.gsub(/\e\[[0-9;]*m/, '')
  end
end

module Rcurses
  def self.clear_screen
    print "\e[2J\e[H"
  end
end