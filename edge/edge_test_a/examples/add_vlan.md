# Add a VLAN

Create VLAN 10 named `users` on `ceos1`:

```bash
bolt task run edge_test_a::add_vlan vlan_id=10 name=users --targets ceos1
```

Create VLAN 20 in a non-default network instance:

```bash
bolt task run edge_test_a::add_vlan vlan_id=20 network_instance=tenant-a --targets ceos1
```