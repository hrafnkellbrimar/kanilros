# frozen_string_literal: true

require "open3"
require "rbconfig"
require "tmpdir"

CHECKER = File.expand_path("check-action-pins.rb", __dir__)
FULL_SHA = "a" * 40
IMAGE_DIGEST = "b" * 64

def check(content)
  Dir.mktmpdir("action-pin-test") do |directory|
    workflow = File.join(directory, "workflow.yml")
    File.write(workflow, content)
    Open3.capture3(RbConfig.ruby, CHECKER, workflow)
  end
end

def assert(condition, message)
  raise message unless condition
end

stdout, stderr, status = check(<<~YAML)
  jobs:
    build:
      steps:
        - uses: actions/checkout@v7
        - uses: ruby/setup-ruby@v1
YAML
assert(!status.success?, "mutable tags must fail")
assert(stderr.include?("actions/checkout@v7"), "checkout violation must be reported")
assert(stderr.include?("ruby/setup-ruby@v1"), "Ruby setup violation must be reported")
assert(stdout.empty?, "failed checks must not print a success summary")

stdout, stderr, status = check(<<~YAML)
  jobs:
    build:
      steps:
        - uses: actions/checkout@#{FULL_SHA} # v7
        - uses: owner/repository/path/to/action@#{FULL_SHA}
        - uses: ./local-action
        - uses: docker://example/image@sha256:#{IMAGE_DIGEST}
YAML
assert(status.success?, "immutable and local references must pass")
assert(stderr.empty?, "passing checks must not print errors")
assert(stdout.include?("Validated 4 immutable action references"), "success summary must count references")

_stdout, stderr, status = check(<<~'YAML')
  jobs:
    build:
      steps:
        - uses: actions/checkout@deadbeef
        - uses: actions/checkout@main
        - uses: ${{ matrix.action }}
        - uses: docker://example/image:latest
        - { "uses": actions/checkout@v7 }
        - uses : actions/configure-pages@v6
YAML
assert(!status.success?, "short SHAs, branches, expressions, and Docker tags must fail")
assert(stderr.lines.length == 6, "every invalid YAML form must be reported")

puts "Validated action pin policy regressions"
