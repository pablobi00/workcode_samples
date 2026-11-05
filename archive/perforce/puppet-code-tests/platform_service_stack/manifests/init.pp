# This class is the entry point for the platform_service_stack module.
# It selects the Linux or Windows branch based on operating system facts.
class platform_service_stack (
  # This parameter lets callers override the branch selection when needed.
  Optional[Enum['linux', 'windows']] $deployment_branch = lookup('platform_service_stack::deployment_branch', { default_value => undef }),
) {

  # Resolve the effective branch from Hiera only.
  if $deployment_branch != undef {
    $effective_branch = $deployment_branch
  } else {
    fail('platform_service_stack requires platform_service_stack::deployment_branch to be set in Hiera.')
  }

  # Include the Linux branch for RHEL and Ubuntu systems.
  if $effective_branch == 'linux' {
    include platform_service_stack::linux

  # Include the Windows branch for Windows Server systems.
  } elsif $effective_branch == 'windows' {
    include platform_service_stack::windows

  # Fail clearly for unsupported operating systems.
  } else {
    fail("platform_service_stack received an unsupported deployment branch value: ${effective_branch}.")
  }
}
