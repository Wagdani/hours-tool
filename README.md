# hours-tool

A tiny command-line tool that totals up logged hours per person from a CSV.

This is a practice repository — a sandbox for learning the pull request
workflow. It contains no real data.

## Requirements

Bash and awk. On Windows, Git Bash (bundled with Git) has both.

## Usage

Given a file `hours.csv`:

```
name,hours
Amina,2.5
Rashid,1
Amina,0.5
```

Run:

```bash
./hours.sh hours.csv
```

Output:

```
Amina,3.00
Rashid,1.00
```

Names are printed in sorted order, with totals to two decimal places.

## Running the tests

```bash
./test/run_tests.sh
```

The runner prints one line per test and exits non-zero if any fail.
