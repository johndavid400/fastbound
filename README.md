# Fastbound

A Ruby gem for the [FastBound](https://fastbound.com) firearms compliance API.

Click here to view the [Fastbound API Documentation](https://cloud.fastbound.com/swagger/index.html).


## Installation

Add to your Gemfile:

```ruby
gem "fastbound"
```

Or install directly:

```bash
gem install fastbound
```

## Configuration

```ruby
client = Fastbound::Client.new(
  api_key:        "your_api_key",
  account_number: "A001234",
  audit_user:     "user@example.com"  # required for create/update/delete operations
)
```

| Option | Required | Description |
|---|---|---|
| `api_key` | Yes | Your FastBound API key (used as HTTP Basic auth username) |
| `account_number` | Yes | Your FastBound account number |
| `audit_user` | No* | Email address recorded on write operations. Required by the API for POST/PUT/DELETE. |
| `base_url` | No | Override the API base URL (default: `https://cloud.fastbound.com`) |

## Resources

### Account

```ruby
client.account.get
```

### Acquisitions

```ruby
# List acquisitions
client.acquisitions.list(take: 25, skip: 0)
client.acquisitions.list(type: "Purchase", acquired_from_contact_id: "uuid")

# Find by ID or external ID
client.acquisitions.find("uuid")
client.acquisitions.find_by_external_id("my-ext-id")

# Create
client.acquisitions.create(
  date: "2024-01-15",
  type: "Purchase",
  invoice_number: "INV-001",
  external_id: "my-acq-001"
)

# Update
client.acquisitions.update("uuid", invoice_number: "INV-002")

# Delete
client.acquisitions.destroy("uuid")

# Attach a contact
client.acquisitions.attach_contact("acquisition-uuid", "contact-uuid")

# Commit
client.acquisitions.commit("uuid")
client.acquisitions.commit("uuid", list_acquired_items: true)

# Create and commit in one request
client.acquisitions.create_and_commit(
  date: "2024-01-15",
  type: "Purchase",
  contact_id: "contact-uuid",
  items: [{ manufacturer: "Glock", model: "19", serial: "ABC123", type: "Pistol", caliber: "9mm" }]
)

# Create as pending (does not commit)
client.acquisitions.create_as_pending(
  date: "2024-01-15",
  type: "Purchase",
  contact_id: "contact-uuid",
  items: [{ manufacturer: "Glock", model: "19", serial: "ABC123", type: "Pistol", caliber: "9mm" }]
)

# Items
client.acquisitions.get_item("acquisition-uuid", "item-uuid")
client.acquisitions.add_item("acquisition-uuid", manufacturer: "Glock", model: "19", serial: "ABC123", type: "Pistol", caliber: "9mm")
client.acquisitions.add_items("acquisition-uuid", [
  { manufacturer: "Glock", model: "19", serial: "ABC123", type: "Pistol", caliber: "9mm" },
  { manufacturer: "Glock", model: "17", serial: "DEF456", type: "Pistol", caliber: "9mm" }
])
client.acquisitions.update_item("acquisition-uuid", "item-uuid", location: "Safe A")
client.acquisitions.delete_item("acquisition-uuid", "item-uuid")
```

### Attachments

```ruby
# Returns raw binary data
pdf_bytes = client.attachments.download("attachment-uuid")
File.binwrite("attachment.pdf", pdf_bytes)
```

### Contacts

```ruby
# List contacts
client.contacts.list(take: 25, skip: 0)
client.contacts.list(last_name: "Smith", ffl_number: "1-23-456-07-8A-12345")

# Find by ID or external ID
client.contacts.find("uuid")
client.contacts.find_by_external_id("my-ext-id")

# Create
client.contacts.create(
  first_name: "John",
  last_name: "Smith",
  ffl_number: "1-23-456-07-8A-12345",
  ffl_expires: "2026-12-31",
  premise_address1: "123 Main St",
  premise_city: "Anytown",
  premise_state: "TX",
  premise_zip_code: "75001"
)

# Update
client.contacts.update("uuid", email_address: "john@example.com")

# Delete
client.contacts.destroy("uuid")

# Merge two contacts (winning contact receives all data from losing contact)
client.contacts.merge(winning_contact_id: "uuid-1", losing_contact_id: "uuid-2")

# Licenses
client.contacts.get_license("contact-uuid", "license-uuid")
client.contacts.create_license("contact-uuid", type: "FFL", number: "1-23-456-07-8A-12345", expiration: "2026-12-31")
client.contacts.update_license("contact-uuid", "license-uuid", copy_on_file: true)
client.contacts.delete_license("contact-uuid", "license-uuid")
```

### Dispositions

```ruby
# List dispositions
client.dispositions.list(take: 25, skip: 0)
client.dispositions.list(type: "SaleTo", disposed_to_contact_id: "uuid")
client.dispositions.list(include_4473: true)

# List Form 4473 dispositions
client.dispositions.list_4473s(take: 25)
client.dispositions.list_4473s(include_awaiting_completion: true)

# Find by ID or external ID
client.dispositions.find("uuid")
client.dispositions.find_by_external_id("my-ext-id")

# Create standard disposition
client.dispositions.create(type: "SaleTo", date: "2024-01-15", generate_ttsn: true)

# Create special disposition types
client.dispositions.create_nfa(date: "2024-01-15", type: "SaleTo", submission_date: "2024-01-10")
client.dispositions.create_theft_loss(date: "2024-01-15", theft_loss__type: "Theft")
client.dispositions.create_destroyed(date: "2024-01-15", destroyed__description: "Destroyed per ATF")

# Update
client.dispositions.update("uuid", note: "Updated note")

# Delete
client.dispositions.destroy("uuid")

# Attach a contact
client.dispositions.attach_contact("disposition-uuid", "contact-uuid")

# Lock
client.dispositions.lock("uuid")
client.dispositions.lock_by_external_id("my-ext-id")

# Commit
client.dispositions.commit("uuid")
client.dispositions.commit("uuid", list_disposed_items: true)

# Create and commit in one request
client.dispositions.create_and_commit(
  type: "SaleTo",
  date: "2024-01-15",
  contact_id: "contact-uuid",
  items: [{ id: "item-uuid", price: 500.00 }]
)

# Create as pending (does not commit)
client.dispositions.create_as_pending(
  type: "SaleTo",
  date: "2024-01-15",
  contact_id: "contact-uuid",
  items: [{ id: "item-uuid", price: 500.00 }]
)

# Items
client.dispositions.list_items("disposition-uuid")
client.dispositions.add_items("disposition-uuid", [{ id: "item-uuid", price: 500.00 }])
client.dispositions.add_items_by_external_id("disp-ext-id", [{ external_id: "item-ext-id", price: 500.00 }])
client.dispositions.add_items_by_search("disp-ext-id", manufacturer: "Glock", model: "19", caliber: "9mm")
client.dispositions.edit_item_price("disposition-uuid", "item-uuid", price: 550.00)
client.dispositions.remove_item("disposition-uuid", "item-uuid")
client.dispositions.remove_item_by_external_id("disposition-uuid", "item-ext-id")
```

### Downloads

```ruby
# Download bound book as binary (PDF or CSV depending on API response)
data = client.downloads.bound_book
File.binwrite("bound_book.pdf", data)
```

### Form 4473s

```ruby
# Returns raw binary PDF data
pdf_bytes = client.form4473s.download("form4473-uuid")
File.binwrite("form4473.pdf", pdf_bytes)
```

### Inventory

```ruby
# Bulk verify inventory by serial number
result = client.inventory.bulk_verify(
  serials: ["ABC123", "DEF456", "GHI789"],
  rollback_partial: true,
  update_location: true,
  location: "Safe A",
  verified_utc: "2024-01-15T10:00:00Z"
)
```

### Items

```ruby
# List items (extensive filtering available)
client.items.list(take: 25, skip: 0)
client.items.list(manufacturer: "Glock", caliber: "9mm", status: 1)
client.items.list(serial: "ABC123")
client.items.list(acquired_on_or_after: "2024-01-01", acquired_on_or_before: "2024-12-31")
client.items.list(is_theft_loss: false, is_destroyed: false)

# Find by ID or external ID
client.items.find("uuid")
client.items.find_by_external_id("my-ext-id")

# Update
client.items.update("uuid", location: "Safe B", note: "Cleaned and inspected")

# Delete (logical delete with type)
client.items.delete("uuid", delete_type: "Destroyed", delete_note: "Per ATF guidelines")

# Set acquisition contact
client.items.set_acquisition_contact("item-uuid", "contact-uuid")

# Undispose
client.items.undispose("uuid")
client.items.undispose("uuid", note: "Returned by customer")

# Set external IDs
client.items.set_external_id("uuid", external_id: "my-item-001")
client.items.set_external_ids([
  { id: "uuid-1", external_id: "my-item-001" },
  { id: "uuid-2", external_id: "my-item-002" }
])
```

### Multiple Sale Reports

```ruby
# Returns raw binary PDF data
pdf_bytes = client.multiple_sale_reports.download("report-uuid", "attachment-uuid")
File.binwrite("multiple_sale_report.pdf", pdf_bytes)
```

### Smart Lists

Smart lists return the allowed values for various fields in your account.

```ruby
client.smart_lists.acquire_types
client.smart_lists.calibers
client.smart_lists.conditions
client.smart_lists.countries_of_manufacture
client.smart_lists.delete_types
client.smart_lists.dispose_types
client.smart_lists.importers
client.smart_lists.item_types
client.smart_lists.license_types
client.smart_lists.locations
client.smart_lists.manufacturers
client.smart_lists.theft_loss_types
client.smart_lists.manufacturing_dispose_types
client.smart_lists.manufacturing_acquire_types
```

### Users

```ruby
client.users.list
client.users.list(include_disabled: true)
```

### Webhooks

```ruby
# List available webhook events
client.webhooks.list_events

# Find a webhook by name
client.webhooks.find("my-webhook")

# Create a webhook
client.webhooks.create(
  name: "my-webhook",
  url: "https://example.com/webhooks/fastbound",
  description: "Acquisition notifications",
  events: ["acquisition.committed", "disposition.committed"]
)

# Update a webhook
client.webhooks.update("my-webhook", url: "https://example.com/webhooks/v2")

# Delete a webhook
client.webhooks.destroy("my-webhook")
```

## Error Handling

```ruby
begin
  client.contacts.find("nonexistent-uuid")
rescue Fastbound::NotFoundError => e
  puts "Not found: #{e.message}"
rescue Fastbound::UnprocessableEntityError => e
  puts "Validation failed: #{e.errors.join(", ")}"
rescue Fastbound::UnauthorizedError => e
  puts "Auth error: #{e.message}"
rescue Fastbound::ApiError => e
  puts "API error #{e.status}: #{e.message}"
end
```

| Exception | HTTP Status |
|---|---|
| `Fastbound::UnauthorizedError` | 401, 403 |
| `Fastbound::NotFoundError` | 404 |
| `Fastbound::UnprocessableEntityError` | 400, 422 |
| `Fastbound::ApiError` | All other errors |

## License

MIT
