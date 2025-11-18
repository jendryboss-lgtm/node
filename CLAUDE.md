# CLAUDE.md - Node.js Codebase Guide for AI Assistants

**Last Updated**: 2025-11-18
**Node.js Version**: Development (main branch)

This document provides comprehensive guidance for AI assistants working on the Node.js codebase. It covers repository structure, development workflows, coding conventions, and key patterns to follow when making contributions.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Repository Structure](#repository-structure)
3. [Development Environment Setup](#development-environment-setup)
4. [Build System](#build-system)
5. [Testing Framework](#testing-framework)
6. [Code Style & Linting](#code-style--linting)
7. [Development Workflow](#development-workflow)
8. [Key Patterns & Conventions](#key-patterns--conventions)
9. [Common Tasks for AI Assistants](#common-tasks-for-ai-assistants)
10. [Important Files & Directories](#important-files--directories)
11. [Resources](#resources)

---

## Project Overview

### What is Node.js?

Node.js is an open-source, cross-platform JavaScript runtime environment that executes JavaScript code outside of a web browser. It is built on:
- **V8 JavaScript Engine** (from Google Chrome)
- **libuv** (for asynchronous I/O)
- **Other dependencies** (OpenSSL, zlib, ICU, etc.)

### Project Governance

- **Organization**: [OpenJS Foundation](https://openjsf.org/)
- **Governance Model**: Open governance with a Technical Steering Committee (TSC)
- **TSC Members**: ~19 voting members + ~7 regular members
- **Collaborators**: 300+ with commit access
- **License**: MIT License

### Release Cadence

- **Major versions**: Every 6 months (April and October)
- **LTS releases**: Even-numbered major versions (12 months Active LTS + 18 months Maintenance)
- **Current releases**: Odd-numbered versions (8 months support)
- **Nightly builds**: Daily builds from main branch

### Key Principles

1. **Collaborative development**: Consensus-seeking process
2. **Backward compatibility**: SemVer compliance, deprecation process
3. **Performance**: Performance regressions block releases
4. **Security**: Responsible disclosure, security stewards
5. **Quality**: Comprehensive test coverage required

---

## Repository Structure

### Top-Level Directories

```
node/
├── lib/                    # Core JavaScript library modules (347 files)
├── src/                    # C++ implementation (232 .cc files, 256 .h files)
├── test/                   # Test suite (3,773 parallel + 109 sequential tests)
├── deps/                   # External dependencies (V8, libuv, OpenSSL, npm, etc.)
├── tools/                  # Build tools, linters, utilities
├── doc/                    # Documentation (API docs, guides)
├── benchmark/              # Performance benchmarking suite
├── out/                    # Build output (generated, not in git)
└── node_modules/           # npm dependencies (generated, not in git)
```

### Core Library (`/lib/`)

JavaScript modules that form the Node.js public API:

**Streams**:
- `_stream_readable.js`, `_stream_writable.js`, `_stream_transform.js`, `_stream_duplex.js`

**HTTP/HTTPS**:
- `_http_server.js`, `_http_client.js`, `_http_agent.js`, `_http_incoming.js`, `_http_outgoing.js`
- `http.js`, `https.js`, `http2.js`

**Core APIs**:
- `fs.js`, `path.js`, `util.js`, `assert.js`, `events.js`, `buffer.js`, `crypto.js`
- `process.js`, `child_process.js`, `cluster.js`, `os.js`
- `timers.js`, `async_hooks.js`, `diagnostics_channel.js`

**Network**:
- `dgram.js` (UDP), `dns.js`, `net.js` (TCP), `tls.js` (TLS/SSL)

**Modern Features**:
- `worker_threads.js`, `sqlite.js` (v22+), ES module loaders

**Convention**: Internal modules are prefixed with `_` (e.g., `_stream_readable.js`)

### C++ Source Code (`/src/`)

Native implementation of Node.js runtime:

```
src/
├── node.cc                 # Main entry point
├── node_main.cc            # Platform-specific main
├── env.cc/env.h            # Environment/context management
├── api/                    # Node-API (N-API) bindings
├── crypto/                 # Cryptography implementation
├── quic/                   # QUIC protocol support
├── inspector/              # V8 Inspector integration
├── permission/             # Permission system
├── tracing/                # Diagnostic tracing
├── node_*.cc               # Module implementations (http2, zlib, buffer, etc.)
└── *_wrap.cc               # libuv wrappers (handle_wrap, stream_wrap, etc.)
```

**Key files**:
- `node_binding.cc` - Native module registration
- `node_api.cc` - Node-API implementation
- `node_buffer.cc` - Buffer implementation
- `node_file.cc` - File system operations
- `node_http2.cc` - HTTP/2 implementation
- `node_worker.cc` - Worker threads

### Test Suite (`/test/`)

```
test/
├── parallel/               # Tests that run in parallel (3,773 files)
├── sequential/             # Tests that must run sequentially (109 files)
├── fixtures/               # Test data and helper files
├── common/                 # Shared test utilities
├── addons/                 # Native addon tests (48 subdirectories)
├── node-api/               # Node-API binding tests (27 subdirectories)
├── js-native-api/          # JS-Native API tests (34 subdirectories)
├── es-module/              # ES module tests
├── wpt/                    # Web Platform Tests
├── cctest/                 # C++ unit tests (GoogleTest)
├── embedding/              # Embedding examples
├── message/                # Error message tests
├── test-runner/            # Built-in test runner tests
└── known_issues/           # Tests for known issues
```

### Dependencies (`/deps/`)

External dependencies bundled with Node.js:
- `v8/` - V8 JavaScript engine
- `uv/` - libuv (async I/O)
- `openssl/` - OpenSSL (crypto/TLS)
- `npm/` - npm package manager
- `icu-small/` - ICU (internationalization)
- `zlib/` - zlib compression
- `nghttp2/` - HTTP/2 implementation
- `llhttp/` - HTTP parser
- `cares/` - DNS resolver
- And 20+ more...

### Documentation (`/doc/`)

```
doc/
├── api/                    # API documentation (generated from source)
├── contributing/           # Contribution guides (45+ guides)
├── changelogs/             # Version-specific changelogs
└── api_assets/             # Images and assets
```

**Key contributing guides**:
- `collaborator-guide.md` - Guide for collaborators
- `pull-requests.md` - Pull request process
- `writing-tests.md` - How to write tests
- `cpp-style-guide.md` - C++ style guide
- `commit-queue.md` - Automated commit queue

---

## Development Environment Setup

### Prerequisites

**All Platforms**:
- **Git** (for version control)
- **Python** 3.9+ (for build scripts)
- **C++ Compiler** (see platform-specific requirements)

**Unix/Linux/macOS**:
- GCC 10.1+ or Clang 13.0+
- GNU Make
- Python 3.9+

**macOS Specific**:
- Xcode 16 (for macOS 13.5+ target)
- Command Line Tools: `xcode-select --install`

**Windows Specific**:
- Visual Studio 2022 or Build Tools
- Python 3.9+
- Windows 10/Server 2016 or later

**Optional**:
- `ccache` (speeds up rebuilds)
- `ninja` (alternative build system)

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/nodejs/node.git
cd node

# Configure the build
./configure

# Build Node.js (use -j for parallel build)
make -j4

# Run the test suite
make test

# Run linters
make lint
```

### Common Configuration Options

```bash
# Debug build
./configure --debug
make -j4

# Shared OpenSSL
./configure --shared-openssl

# Full ICU support (all locales)
./configure --with-intl=full-icu

# Without internationalization
./configure --with-intl=none

# Custom OpenSSL directory
./configure --shared-openssl --shared-openssl-includes=/path/to/include --shared-openssl-libpath=/path/to/lib

# See all options
./configure --help
```

### Windows Build

```cmd
# Using vcbuild.bat
vcbuild.bat

# Debug build
vcbuild.bat debug

# 64-bit build
vcbuild.bat x64
```

### Development Workflow Setup

```bash
# Set up git hooks (optional but recommended)
git config --global apply.whitespace fix

# Install ccache for faster rebuilds (optional)
# macOS
brew install ccache
# Linux
sudo apt-get install ccache

# Configure to use ccache
export CC="ccache gcc"
export CXX="ccache g++"
./configure
```

---

## Build System

### Build Tools

Node.js uses a combination of build tools:
- **GYP** (Generate Your Projects) - Main build configuration
- **Python** - Configuration and tool scripts
- **Make** - Unix/Linux/macOS builds
- **MSBuild/vcbuild.bat** - Windows builds

### Key Build Files

| File | Purpose |
|------|---------|
| `configure` / `configure.py` | Configuration script (generates `config.mk`) |
| `Makefile` | Unix/Linux/macOS build automation (61KB) |
| `vcbuild.bat` | Windows build script (36KB) |
| `node.gyp` | Main GYP build configuration (47KB) |
| `node.gypi` | Shared GYP definitions |
| `common.gypi` | Common build variables |
| `config.mk` | Generated build configuration |

### Build Targets

```bash
# Build Node.js binary
make

# Run all tests
make test

# Run specific test suites
make test-parallel        # Parallel tests only
make test-sequential      # Sequential tests only
make test-addons          # Native addon tests
make test-js-native-api   # Node-API tests

# Run linters
make lint                 # All linters
make lint-js              # JavaScript linting (ESLint)
make lint-cpp             # C++ linting (cpplint)
make lint-md              # Markdown linting

# Build and run benchmarks
make bench

# Generate code coverage
make coverage

# Build documentation
make doc

# Clean build artifacts
make clean

# Install to system (default: /usr/local)
make install
```

### Speeding Up Rebuilds

**Using ccache**:
```bash
# Install ccache
# macOS: brew install ccache
# Linux: apt-get install ccache

# Configure
export CC="ccache gcc"
export CXX="ccache g++"
./configure
```

**Load JS files from disk** (for rapid iteration on JS files):
```bash
./configure --node-builtin-modules-path=$(pwd)
```

This avoids re-embedding JavaScript files into the binary on every build.

---

## Testing Framework

### Test Organization

Node.js uses a custom test framework with the following structure:

**Test Categories**:
1. **Parallel tests** (`test/parallel/`) - Run concurrently (3,773 tests)
2. **Sequential tests** (`test/sequential/`) - Run one at a time (109 tests)
3. **C++ tests** (`test/cctest/`) - GoogleTest framework
4. **Addon tests** (`test/addons/`) - Native module tests
5. **Node-API tests** (`test/node-api/`) - N-API binding tests
6. **ES module tests** (`test/es-module/`) - ESM functionality
7. **WPT tests** (`test/wpt/`) - Web Platform Tests

### Running Tests

```bash
# Run all tests
make test

# Run specific test file
./node test/parallel/test-http-server.js

# Run test with built-in test runner
./node --test test/parallel/test-http-server.js

# Run tests matching a pattern
python tools/test.py parallel/test-http*

# Run sequential tests
make test-sequential

# Run with specific Node.js binary
./node test/parallel/test-http-server.js

# Run in debug mode
./node --inspect-brk test/parallel/test-http-server.js
```

### Test File Naming

**Convention**: `test-<subsystem>-<description>.js`

Examples:
- `test-http-server-request.js`
- `test-stream-readable-event-data.js`
- `test-fs-readfile-error.js`

### Test Structure

```javascript
'use strict';
const common = require('../common');
const assert = require('assert');
const http = require('http');

// Test description
// This test ensures that HTTP server properly handles requests

const server = http.createServer(common.mustCall((req, res) => {
  assert.strictEqual(req.url, '/test');
  res.end('ok');
}));

server.listen(0, common.mustCall(() => {
  const { port } = server.address();

  http.get(`http://localhost:${port}/test`, common.mustCall((res) => {
    assert.strictEqual(res.statusCode, 200);
    server.close();
  }));
}));
```

### Test Utilities (`test/common/`)

Key utilities from `test/common/index.js`:

```javascript
const common = require('../common');

// Ensure callback is called expected number of times
common.mustCall(fn, [exact]);
common.mustCallAtLeast(fn, minimum);
common.mustNotCall();

// Skip test if condition is met
common.skip('reason');

// Platform detection
if (common.isWindows) { /* ... */ }
if (common.isLinux) { /* ... */ }
if (common.isMacOS) { /* ... */ }

// Temporary directories
const tmpdir = require('../common/tmpdir');
tmpdir.refresh();
const testFile = tmpdir.resolve('test.txt');

// Port management
const { createServer } = require('net');
const server = createServer();
server.listen(0); // Bind to random available port
```

### Assertions

Always use strict assertions:

```javascript
const assert = require('assert');

// Preferred
assert.strictEqual(actual, expected);
assert.deepStrictEqual(actual, expected);
assert.throws(() => { ... }, expectedError);

// Avoid (non-strict)
assert.equal(actual, expected);        // Don't use
assert.deepEqual(actual, expected);    // Don't use
```

### Test Coverage

```bash
# Generate coverage report
make coverage

# Coverage is tracked via NYC (New York Code Coverage)
# Reports are generated in coverage/
```

---

## Code Style & Linting

### JavaScript Style

**Linter**: ESLint (modern flat config in `eslint.config.mjs`)

**Key Rules**:
- **Indentation**: 2 spaces (no tabs)
- **Quotes**: Single quotes for strings (`'string'`)
- **Semicolons**: Always use semicolons
- **Line length**: 80 characters (soft limit)
- **Trailing commas**: Use in multi-line arrays/objects
- **Strict mode**: Always `'use strict';` in non-module files

**Naming Conventions**:
- **Variables/Functions**: `camelCase`
- **Classes/Constructors**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE` or `camelCase` (context-dependent)
- **Private methods**: Prefix with `_` (e.g., `_internalMethod`)
- **Internal modules**: Prefix filename with `_` (e.g., `_stream_readable.js`)

**Example**:
```javascript
'use strict';

const { EventEmitter } = require('events');
const { validateString } = require('internal/validators');

const kState = Symbol('state');
const DEFAULT_TIMEOUT = 1000;

class MyClass extends EventEmitter {
  constructor(options = {}) {
    super();
    this[kState] = 'initial';
    this._internalValue = options.value;
  }

  _privateMethod() {
    // Implementation
  }

  publicMethod(input) {
    validateString(input, 'input');
    return this._privateMethod();
  }
}

module.exports = MyClass;
```

### C++ Style

**Formatter**: clang-format (`.clang-format` config based on Google style)

**Key Rules**:
- **Indentation**: 2 spaces
- **Line length**: 80 characters
- **Braces**: Attached style (opening brace on same line)
- **Pointer alignment**: Left (`int* ptr` not `int *ptr`)
- **Header guards**: `#ifndef NODE_SRC_MODULE_NAME_H_` format

**Naming Conventions**:
- **Classes**: `PascalCase` (e.g., `Environment`, `BaseObject`)
- **Functions**: `PascalCase` or `snake_case` (context-dependent)
- **Variables**: `snake_case`
- **Constants**: `kPascalCase` (e.g., `kMaxLength`)
- **Macros**: `UPPER_SNAKE_CASE`

**Example**:
```cpp
#ifndef SRC_NODE_EXAMPLE_H_
#define SRC_NODE_EXAMPLE_H_

#include "node.h"
#include "v8.h"

namespace node {

constexpr size_t kMaxBufferSize = 1024;

class Example : public BaseObject {
 public:
  Example(Environment* env, v8::Local<v8::Object> object);
  ~Example() override;

  void DoSomething();

  SET_MEMORY_INFO_NAME(Example)
  SET_SELF_SIZE(Example)

 private:
  int internal_state_;
  void InternalMethod();
};

}  // namespace node

#endif  // SRC_NODE_EXAMPLE_H_
```

### Linting

```bash
# Run all linters
make lint

# JavaScript only (ESLint)
make lint-js

# C++ only (cpplint)
make lint-cpp

# C++ format check
make format-cpp-check

# Apply C++ formatting
make format-cpp

# Markdown linting
make lint-md

# Check commit messages
make lint-commit-messages
```

### Pre-commit Checks

Before committing, ensure:
1. All linters pass: `make lint`
2. Tests pass: `make test` (or at least affected subsystem tests)
3. No trailing whitespace
4. Commit message follows convention

---

## Development Workflow

### Making Changes

**Standard workflow**:

1. **Create a branch**:
   ```bash
   git checkout -b my-feature-branch
   ```

2. **Make changes**:
   - Edit code in `lib/` (JavaScript) or `src/` (C++)
   - Add/update tests in `test/`
   - Update documentation if needed

3. **Run linters**:
   ```bash
   make lint
   ```

4. **Run tests**:
   ```bash
   # Run affected subsystem tests
   python tools/test.py parallel/test-http*

   # Or run all tests
   make test
   ```

5. **Commit changes**:
   ```bash
   git add .
   git commit
   ```

### Commit Message Format

**Format**: `subsystem: brief description`

**Subsystems**: `http`, `fs`, `stream`, `crypto`, `test`, `doc`, `build`, `worker`, `lib`, `src`, etc.

**Examples**:
```
http: fix memory leak in server close
test: add coverage for stream destroy
doc: clarify fs.readFile error handling
crypto: update OpenSSL to 3.0.12
stream: improve performance of pipe()
```

**For breaking changes**:
```
BREAKING CHANGE: remove deprecated util.isBuffer

This removes util.isBuffer which was deprecated in Node.js 10.

Fixes: https://github.com/nodejs/node/issues/12345
PR-URL: https://github.com/nodejs/node/pull/67890
Reviewed-By: Jane Doe <jane@example.com>
Reviewed-By: John Smith <john@example.com>
```

### Pull Request Process

1. **Push to your fork**:
   ```bash
   git push origin my-feature-branch
   ```

2. **Open PR** on GitHub against `main` branch

3. **PR Title**: Follow commit message format
   - Example: `http: fix memory leak in server close`

4. **PR Description**:
   - Explain what the PR does and why
   - Link related issues: `Fixes: #12345` or `Refs: #67890`
   - Include test plan if applicable

5. **Wait for reviews**:
   - **Two collaborator approvals** required (or one if > 7 days old)
   - CI must pass on all platforms
   - Address review feedback

6. **Collaborators will land** (merge) the PR when approved

### Automated Commit Queue

For approved PRs, collaborators can add label `commit-queue` to automatically merge when CI passes.

### SemVer Labels

PRs are labeled based on semantic versioning impact:
- `semver-patch`: Bug fixes, no breaking changes
- `semver-minor`: New features, backward compatible
- `semver-major`: Breaking changes

---

## Key Patterns & Conventions

### Module Organization

**CommonJS modules** (`/lib/*.js`):
```javascript
'use strict';

// Internal dependencies first
const { validateString } = require('internal/validators');
const { codes } = require('internal/errors');

// External/built-in dependencies
const EventEmitter = require('events');

// Constants
const kState = Symbol('state');

// Implementation
class MyClass {
  // ...
}

// Exports
module.exports = MyClass;
```

**ES Modules** (`/lib/*.mjs`):
```javascript
import { validateString } from 'internal/validators';

export class MyClass {
  // ...
}

export default MyClass;
```

### Internal APIs

Internal modules are in `lib/internal/`:
- Not exposed to users
- Can change without semver-major
- Used for code sharing between modules

**Access internal modules**:
```javascript
const { validateString } = require('internal/validators');
const { codes } = require('internal/errors');
```

### Error Handling

**Use error codes** from `lib/internal/errors.js`:

```javascript
const { codes } = require('internal/errors');
const {
  ERR_INVALID_ARG_TYPE,
  ERR_OUT_OF_RANGE,
} = codes;

function myFunction(value) {
  if (typeof value !== 'string') {
    throw new ERR_INVALID_ARG_TYPE('value', 'string', value);
  }

  if (value.length > 100) {
    throw new ERR_OUT_OF_RANGE('value.length', '<= 100', value.length);
  }
}
```

### Input Validation

**Use validators** from `lib/internal/validators.js`:

```javascript
const {
  validateString,
  validateInteger,
  validateObject,
} = require('internal/validators');

function myFunction(str, num, obj) {
  validateString(str, 'str');
  validateInteger(num, 'num', 0, 100);
  validateObject(obj, 'obj');
}
```

### Symbols for Private State

Use symbols for private properties to avoid naming conflicts:

```javascript
const kState = Symbol('state');
const kQueue = Symbol('queue');

class MyClass {
  constructor() {
    this[kState] = 'initial';
    this[kQueue] = [];
  }
}
```

### Primordials

For security and stability, use primordials (frozen built-in prototypes):

```javascript
const {
  ArrayPrototypePush,
  ObjectDefineProperty,
  StringPrototypeSlice,
} = primordials;

// Instead of: array.push(item)
ArrayPrototypePush(array, item);

// Instead of: str.slice(0, 10)
StringPrototypeSlice(str, 0, 10);
```

See `lib/internal/per_context/primordials.js` and `doc/contributing/primordials.md`.

### Deprecation Process

1. **Add deprecation** with `process.emitWarning()`:
   ```javascript
   process.emitWarning(
     'util.isBuffer() is deprecated. Use Buffer.isBuffer() instead.',
     'DeprecationWarning',
     'DEP0XXX'
   );
   ```

2. **Document** in `doc/api/deprecations.md`

3. **Runtime deprecation** (semver-minor)
   - Warning emitted when used

4. **End-of-Life** (semver-major)
   - Remove functionality entirely

---

## Common Tasks for AI Assistants

### Adding a New API to an Existing Module

**Example: Adding a new method to `fs` module**

1. **Add implementation** in `/lib/fs.js`:
   ```javascript
   function myNewFunction(path, options) {
     validateString(path, 'path');
     // Implementation
   }

   module.exports = {
     // ... existing exports
     myNewFunction,
   };
   ```

2. **Add tests** in `/test/parallel/test-fs-my-new-function.js`:
   ```javascript
   'use strict';
   const common = require('../common');
   const assert = require('assert');
   const fs = require('fs');

   // Test cases
   ```

3. **Add documentation** in `/doc/api/fs.md`:
   ````markdown
   ## `fs.myNewFunction(path[, options])`

   * `path` {string}
   * `options` {Object}
   * Returns: {void}

   Description of the function.
   ````

4. **Run tests and linters**:
   ```bash
   make lint
   python tools/test.py parallel/test-fs-my-new-function
   ```

### Fixing a Bug

1. **Reproduce the bug** with a test case

2. **Locate the bug** in `/lib/` or `/src/`

3. **Fix the code**

4. **Add regression test** in `/test/parallel/`:
   ```javascript
   // Regression test for https://github.com/nodejs/node/issues/12345
   ```

5. **Verify fix**:
   ```bash
   make lint
   python tools/test.py parallel/test-*
   ```

6. **Commit with reference**:
   ```
   subsystem: fix issue with ...

   Fixes: https://github.com/nodejs/node/issues/12345
   ```

### Updating Dependencies

**Example: Updating V8**

1. **Update dependency** in `/deps/v8/`

2. **Update version** in `deps/v8/include/v8-version.h`

3. **Run tests**:
   ```bash
   make test
   ```

4. **Check for backports** needed in `src/` bindings

5. **Update documentation** if API changed

### Adding C++ Bindings

1. **Create C++ implementation** in `/src/node_mymodule.cc`

2. **Register binding** in `src/node_binding.cc`:
   ```cpp
   NODE_BINDING_CONTEXT_AWARE_INTERNAL(mymodule, node::mymodule::Initialize)
   ```

3. **Create JavaScript wrapper** in `/lib/internal/mymodule.js`:
   ```javascript
   const { mymodule } = internalBinding('mymodule');
   ```

4. **Add to GYP** in `node.gyp`:
   ```python
   'sources': [
     'src/node_mymodule.cc',
     # ...
   ]
   ```

5. **Write tests** in `/test/parallel/`

---

## Important Files & Directories

### Configuration Files

| File | Purpose |
|------|---------|
| `eslint.config.mjs` | ESLint configuration (flat config) |
| `.clang-format` | C++ code formatting (clang-format) |
| `.cpplint` | C++ linting configuration |
| `.editorconfig` | Editor settings (indentation, etc.) |
| `tsconfig.json` | TypeScript configuration (for tooling) |
| `.gitignore` | Git ignored files |
| `.gitattributes` | Git attributes (line endings, etc.) |
| `.nycrc` | Code coverage configuration (NYC) |
| `codecov.yml` | Codecov integration |
| `pyproject.toml` | Python tools configuration (Ruff linter) |
| `.mailmap` | Git author mapping |

### Build & CI

| File/Directory | Purpose |
|----------------|---------|
| `Makefile` | Main build automation (Unix/Linux/macOS) |
| `vcbuild.bat` | Windows build script |
| `configure` / `configure.py` | Build configuration script |
| `node.gyp` | GYP build configuration |
| `common.gypi` | Common GYP settings |
| `.github/workflows/` | GitHub Actions CI/CD (30+ workflows) |
| `tools/` | Build tools, linters, utilities |

### Documentation

| File/Directory | Purpose |
|----------------|---------|
| `README.md` | Project overview |
| `BUILDING.md` | Build instructions (all platforms) |
| `CONTRIBUTING.md` | Contribution guidelines |
| `GOVERNANCE.md` | Project governance structure |
| `SECURITY.md` | Security policies |
| `onboarding.md` | Collaborator onboarding |
| `glossary.md` | Technical terminology |
| `CHANGELOG.md` | Version history |
| `doc/api/` | API documentation |
| `doc/contributing/` | Contributing guides (45+ docs) |

### Key Source Files

**JavaScript Core**:
- `lib/internal/bootstrap/node.js` - Bootstrap process
- `lib/internal/modules/cjs/loader.js` - CommonJS module loader
- `lib/internal/modules/esm/loader.js` - ES module loader
- `lib/internal/errors.js` - Error codes and classes
- `lib/internal/validators.js` - Input validation utilities

**C++ Core**:
- `src/node.cc` - Main runtime entry point
- `src/node_main.cc` - Platform-specific main()
- `src/env.cc` / `src/env.h` - Environment/context
- `src/node_binding.cc` - Module binding registration
- `src/node_api.cc` - Node-API (N-API) implementation

---

## Resources

### Official Documentation

- **Website**: https://nodejs.org/
- **API Docs**: https://nodejs.org/api/
- **Contributing**: https://github.com/nodejs/node/blob/main/CONTRIBUTING.md
- **Building**: https://github.com/nodejs/node/blob/main/BUILDING.md

### Key Guides

- **Collaborator Guide**: `/doc/contributing/collaborator-guide.md`
- **Pull Requests**: `/doc/contributing/pull-requests.md`
- **Writing Tests**: `/doc/contributing/writing-tests.md`
- **C++ Style Guide**: `/doc/contributing/cpp-style-guide.md`
- **Commit Queue**: `/doc/contributing/commit-queue.md`

### Development Resources

- **Issue Tracker**: https://github.com/nodejs/node/issues
- **Discussions**: https://github.com/nodejs/node/discussions
- **Release Schedule**: https://github.com/nodejs/Release
- **Node.js Core Utils**: https://www.npmjs.com/package/@node-core/utils

### Communication

- **Slack**: #nodejs-core on OpenJS Foundation Slack
- **TSC Meetings**: Public on YouTube
- **Working Groups**: https://github.com/nodejs/TSC/blob/HEAD/WORKING_GROUPS.md

---

## Quick Reference

### File Locations by Task

| Task | Location |
|------|----------|
| Add HTTP API | `/lib/http.js`, `/lib/_http_*.js` |
| Add FS API | `/lib/fs.js`, `/lib/internal/fs/` |
| Add Stream API | `/lib/stream.js`, `/lib/_stream_*.js` |
| Add C++ binding | `/src/node_*.cc` |
| Add test | `/test/parallel/test-*.js` |
| Add docs | `/doc/api/*.md` |
| Update dependency | `/deps/<dependency>/` |

### Common Commands

```bash
# Build
./configure && make -j4

# Test
make test                      # All tests
python tools/test.py <path>    # Specific test(s)

# Lint
make lint                      # All linters
make lint-js                   # JavaScript
make lint-cpp                  # C++

# Debug
./node --inspect-brk test/parallel/test-*.js

# Coverage
make coverage

# Clean
make clean
```

### Subsystem Labels

When creating commits or PRs, use these subsystem prefixes:

`assert`, `async_hooks`, `benchmark`, `buffer`, `build`, `child_process`, `cluster`, `console`, `crypto`, `debugger`, `deps`, `dgram`, `dns`, `doc`, `errors`, `esm`, `events`, `fs`, `http`, `http2`, `https`, `inspector`, `lib`, `module`, `net`, `os`, `path`, `perf_hooks`, `process`, `querystring`, `readline`, `repl`, `report`, `src`, `stream`, `string_decoder`, `test`, `timers`, `tls`, `tools`, `trace_events`, `tty`, `url`, `util`, `v8`, `vm`, `worker`, `zlib`

---

## Best Practices for AI Assistants

### When Making Changes

1. **Always read existing code first** to understand patterns
2. **Follow established conventions** in the file/module
3. **Add tests** for any new functionality or bug fixes
4. **Update documentation** if API changes
5. **Run linters** before committing: `make lint`
6. **Run relevant tests**: `python tools/test.py parallel/test-<subsystem>*`
7. **Use descriptive commit messages** following subsystem convention
8. **Check for similar issues** in the issue tracker

### Code Quality

1. **Validate inputs** using `lib/internal/validators.js`
2. **Use error codes** from `lib/internal/errors.js`
3. **Avoid breaking changes** unless absolutely necessary (semver-major)
4. **Consider performance** implications
5. **Use primordials** in core library code for security
6. **Document complex logic** with comments
7. **Keep functions small** and focused

### Testing

1. **Write tests first** (TDD) when fixing bugs
2. **Use `common.mustCall()`** to ensure callbacks are invoked
3. **Use strict assertions**: `assert.strictEqual()`, not `assert.equal()`
4. **Test error cases** as well as success cases
5. **Clean up resources** (close servers, remove temp files)
6. **Use descriptive test names**: `test-<subsystem>-<description>.js`

### Documentation

1. **Update API docs** in `/doc/api/*.md` for public API changes
2. **Include examples** in documentation
3. **Document parameters** with types and descriptions
4. **Add deprecation notices** if removing functionality
5. **Keep CHANGELOG** updated for notable changes

---

**Last Updated**: 2025-11-18
**Maintained By**: Node.js Community
**For Updates**: See [nodejs/node](https://github.com/nodejs/node)
