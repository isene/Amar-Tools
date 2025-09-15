# Claude Code Instructions for Amar-Tools

## CRITICAL: Always Use rcurses

**NEVER use raw ANSI escape codes!** Always use rcurses string extensions for ALL terminal operations:

### Coloring
- Use `.fg(color)` for foreground colors (e.g., `"text".fg(226)`)
- Use `.bg(color)` for background colors (e.g., `"text".bg(28)`)
- Use `.b` for bold text (e.g., `"text".b`)
- Use `.u` for underlined text (e.g., `"text".u`)
- Use `.i` for italic text (e.g., `"text".i`)
- Combine with chaining: `"text".fg(226).b` for bold yellow

### Screen Operations
- Use `Rcurses.clear_screen` instead of print "\e[2J\e[H"
- Use `pane.clear` for clearing panes
- Use `pane.refresh` for refreshing content

### Keyboard Input
- Use rcurses key constants: "UP", "DOWN", "LEFT", "RIGHT", "PgUP", "PgDOWN"
- Never use raw escape sequences like "\e[A", "\e[B", etc.

### Important Notes
- The `.pure` method strips ANSI codes from strings
- Always test coloring with `@config[:color_mode]` check
- Use the existing `colorize_output` helper when appropriate

## Project Structure
- Main TUI file: `amar-tui.rb`
- Includes directory contains game logic classes
- Uses rcurses gem for ALL terminal UI operations

## Testing
- Always verify syntax with `ruby -c amar-tui.rb`
- Test that colors display properly in terminal
- Ensure keyboard navigation works with rcurses constants

## Common Patterns
```ruby
# Correct coloring:
output = "Weather: ".fg(14).b + weather_text.fg(226)

# Wrong (never do this):
output = "\e[38;5;14;1mWeather: \e[0m" + weather_text

# Correct key handling:
when "j", "DOWN"
  pane.linedown

# Wrong (never do this):
when "j", "\e[B"
  pane.linedown
```