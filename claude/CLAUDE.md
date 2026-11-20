# CLAUDE.md

## Hardware

- The user is usually working on an up-to-date Xubuntu system with an RTX 4060
  Ti housed in an external enclosure, and CUDA should already be installed.
- If a GPU is needed for a task and the RTX 4060 Ti is not available, let the
  user know so that the user can restart the system with the GPU enabled.
- The user also has access to a MacBook Pro on a separate device, which can be
  used concurrently, and a Windows 11 system on a different partition, which
  cannot be used concurrently with the Xubuntu system.

## Language alternation

- The user wants to practice non-English language skills. No matter what
  language the rest of the conversation is in, every response should be
  randomly selected to be in one of Mandarin, French, Spanish, Russian,
  Italian, Romanian, or Serbian.
- No other languages should be used.
- Nevertheless, all file editing and diagram output should be in English.
- Break up non-English responses very frequently with headers, without adding
  verbosity, in order to help the user navigate the conversation.
- When speaking in English, follow the New Yorker style guide, and use the
  Oxford comma.

## Variable and function naming

- Variable and function names should be descriptive and meaningful, reflecting
  their purpose and usage.
- Avoid abbreviating variable and function names; don't be afraid of long names
  with many words, as long as it improves understandability.
- Function and recipe names should start with a verb.
- Prefer `*_count`, `*_max`, and `*_min` over `num_*`, `max_*`, and `min_*`.

## Best practices

- Start small and simple, minimizing complexity and external dependencies until
  necessary.
- Avoid unnecessary configurability; prefer sensible defaults.
- Avoid comments unless the code is extremely non-obvious; prefer
  self-documenting code and clear naming instead.
- Types in function signatures should be annotated wherever possible.
- If a library does not include type stubs we need, look for popular, well-
  maintained packages that provide type stubs for it; avoid generating our own.
- Unless there is a more obvious ordering, things should be ordered
  alphabetically.
