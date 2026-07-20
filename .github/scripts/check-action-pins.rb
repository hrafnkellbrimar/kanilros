# frozen_string_literal: true

require "yaml"

SHA40 = "[0-9a-fA-F]{40}"
SHA256 = "[0-9a-fA-F]{64}"
GITHUB_REFERENCE = /\A[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+(?:\/[A-Za-z0-9_.\/-]+)?@#{SHA40}\z/
DOCKER_REFERENCE = /\Adocker:\/\/[^@\s]+@sha256:#{SHA256}\z/

def workflow_files(paths)
  paths.flat_map do |path|
    if File.directory?(path)
      Dir.glob(File.join(path, "**", "*.{yml,yaml}"))
    elsif File.file?(path)
      path
    else
      []
    end
  end.uniq.sort
end

def action_references(value, path = [], references = [])
  case value
  when Hash
    value.each do |key, child|
      child_path = path + [key.to_s]
      references << [child_path, child] if key.to_s == "uses"
      action_references(child, child_path, references)
    end
  when Array
    value.each_with_index do |child, index|
      action_references(child, path + [index.to_s], references)
    end
  end

  references
end

def pinned_reference?(reference)
  return false unless reference.is_a?(String)
  return true if reference.start_with?("./")
  return DOCKER_REFERENCE.match?(reference) if reference.start_with?("docker://")

  GITHUB_REFERENCE.match?(reference)
end

paths = ARGV.empty? ? [".github/workflows"] : ARGV
files = workflow_files(paths)

if files.empty?
  warn "No workflow files found in: #{paths.join(', ')}"
  exit 2
end

violations = []
reference_count = 0

files.each do |file|
  workflow = YAML.safe_load(File.read(file), aliases: true)
  action_references(workflow).each do |path, reference|
    reference_count += 1
    next if pinned_reference?(reference)

    violations << "#{file}:#{path.join('.')}: #{reference.inspect} must use a full commit SHA"
  end
rescue Psych::SyntaxError => error
  violations << "#{file}: invalid YAML (#{error.message.lines.first.strip})"
end

unless violations.empty?
  warn violations.join("\n")
  exit 1
end

puts "Validated #{reference_count} immutable action references across #{files.length} workflow files"
