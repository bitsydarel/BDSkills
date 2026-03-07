# Security Review — IoT

## Domain context

IoT devices operate in physically accessible, resource-constrained, and often unmanaged environments. Unlike servers or mobile devices, IoT hardware ships with fixed firmware, limited compute for security operations, and long deployment lifecycles (5-15 years). Devices communicate over specialized protocols (MQTT, CoAP, BLE, Zigbee, Z-Wave) and often lack the ability to run traditional security agents. The combination of physical access, weak defaults, massive scale, and difficult patching makes IoT a uniquely challenging security domain.

## OWASP IoT Top 10 (2018) mapping

| # | Risk | Mapped Criteria |
|---|------|----------------|
| I1:2018 | Weak, Guessable, or Hardcoded Passwords | A1: Authentication |
| I2:2018 | Insecure Network Services | T1: Attack Surface, O3: Hardening |
| I3:2018 | Insecure Ecosystem Interfaces | A3: Input Validation, A1 |
| I4:2018 | Lack of Secure Update Mechanism | A5: Supply Chain |
| I5:2018 | Use of Insecure or Outdated Components | A5: Supply Chain |
| I6:2018 | Insufficient Privacy Protection | G2: Privacy by Design |
| I7:2018 | Insecure Data Transfer and Storage | A4: Data Protection |
| I8:2018 | Lack of Device Management | O3: Infrastructure Hardening |
| I9:2018 | Insecure Default Settings | O3: Infrastructure Hardening |
| I10:2018 | Lack of Physical Hardening | T1: Attack Surface |

## Criterion interpretation for IoT

| Criterion | IoT-Specific Interpretation |
|-----------|---------------------------|
| T1 | Map all physical interfaces (UART, JTAG, USB), wireless protocols (BLE, WiFi, Zigbee), network services, cloud API endpoints, mobile app interfaces |
| T2 | STRIDE including physical threats: device tampering, firmware extraction, RF replay attacks, side-channel analysis |
| T3 | Device → gateway → cloud is primary trust chain. Physical access to device is a trust boundary violation. BLE/Zigbee pairing as trust establishment |
| A1 | Unique per-device credentials (no shared defaults). Certificate-based auth where possible. Secure bootstrapping/provisioning |
| A2 | Device capability-based authorization. Cloud-side access control for device commands. No admin-by-default |
| A3 | Firmware input validation for all protocol handlers. Command injection via MQTT payload. Buffer overflow in protocol parsers |
| A4 | TLS/DTLS for all network communication. Secure storage for credentials on device (secure element, TPM). Encrypted firmware images |
| A5 | Signed firmware updates with rollback protection. Secure boot chain. SBOM for firmware dependencies. OTA update mechanism security |
| A6 | Memory-safe firmware development. Watchdog timers. Stack canaries. ASLR where supported. Resource limits on constrained devices |
| O1 | Device health reporting to cloud. Anomalous behavior detection (unusual network patterns, unexpected commands). Fleet-wide monitoring |
| O3 | Disable unused services and ports. Minimal firmware (no debug shells in production). Secure defaults (no default passwords, no open ports) |
| O4 | Remote recovery mechanism. Firmware rollback to known-good version. Fleet-wide update capability. Bricked device recovery |
| G2 | Sensor data minimization. Local processing where possible. User consent for data collection. Data retention limits |

## Top 5 IoT-specific anti-patterns

### 1. Default Credentials Everywhere

**Signs**: All devices ship with same admin/admin or admin/password credentials. No forced credential change on first setup. Credentials documented in publicly available manuals. Hardcoded credentials in firmware.

**Impact**: Mirai botnet compromised 600K+ devices using 61 known default credentials. Any internet-connected device with default credentials is compromised within minutes.

**Fix**: Unique per-device credentials (printed on device label or generated during provisioning). Force credential change on first setup. No hardcoded credentials in firmware. Certificate-based authentication where possible.

---

### 2. No Secure Update Path

**Signs**: No OTA update mechanism. Updates require physical access. Firmware images transferred over HTTP without signature verification. No rollback capability if update fails. Update server is a single point of failure.

**Impact**: Known vulnerabilities persist for the device's entire lifetime (5-15 years). No ability to respond to security incidents. Device becomes permanently compromised after first exploitation.

**Fix**: Signed firmware updates verified before installation. Secure boot chain to prevent running modified firmware. OTA update over TLS with certificate pinning. Rollback to previous version on update failure. Redundant update infrastructure.

---

### 3. Firmware Extraction and Reverse Engineering

**Signs**: No secure boot enabled. JTAG/UART debug ports accessible without authentication. Firmware stored in plaintext flash. No tamper detection. Encryption keys stored alongside encrypted data on device.

**Impact**: Attackers extract firmware, reverse-engineer protocols, find hardcoded keys, and discover vulnerabilities. One extracted firmware compromises the entire device fleet if credentials are shared.

**Fix**: Enable secure boot with hardware root of trust. Disable or authenticate debug interfaces in production. Use secure elements for key storage. Implement tamper detection. Encrypt firmware with device-specific keys.

---

### 4. Insecure Protocol Implementation

**Signs**: MQTT without authentication or TLS. BLE pairing with Just Works (no MITM protection). CoAP without DTLS. Custom protocols without security analysis. Zigbee with default trust center link key.

**Impact**: Network eavesdropping captures all device communication. MITM attacks inject commands. RF replay attacks repeat legitimate commands (garage door openers, car key fobs). Unauthorized device pairing.

**Fix**: TLS/DTLS for all IP-based communication. BLE: use Secure Connections with Numeric Comparison. MQTT: TLS + client certificates. Custom protocols: formal security analysis and fuzzing. Rotate pairing keys.

---

### 5. Unlimited Device Trust

**Signs**: Cloud backend trusts all data from devices without validation. Device commands executed without authorization checks. No rate limiting on device-to-cloud messages. Device identity not verified per-message.

**Impact**: Compromised device sends malicious data poisoning backend systems. Spoofed device messages trigger unauthorized actions. DoS via message flooding from compromised device fleet.

**Fix**: Validate all device data server-side. Per-device authentication on every message (mutual TLS, JWT). Rate limit per device. Anomaly detection on device behavior. Command authorization at cloud gateway.

---

## Key controls checklist

- [ ] Unique per-device credentials — no shared defaults
- [ ] Secure boot chain with hardware root of trust
- [ ] Signed and encrypted OTA firmware updates with rollback
- [ ] Debug interfaces (JTAG, UART) disabled or authenticated in production
- [ ] TLS/DTLS for all network communication
- [ ] Secure element or TPM for key storage
- [ ] Device provisioning with certificate-based identity
- [ ] Fleet-wide monitoring for anomalous device behavior
- [ ] Minimal attack surface — unused services and ports disabled
- [ ] Physical tamper detection where applicable
- [ ] SBOM for firmware dependencies with CVE monitoring
- [ ] Data minimization — local processing before cloud upload

## Company practices

- **Apple**: HomeKit Accessory Protocol with mandatory encryption, device attestation, local processing preference
- **Google**: Nest/Thread with device certificates, Titan security chip, automatic updates, Project Pauline for IoT fuzzing
- **Amazon**: AWS IoT Device Defender for monitoring, FreeRTOS with TLS, device shadow for secure state management
- **Microsoft**: Azure Sphere with custom Linux + Pluton security chip, Azure IoT Hub device provisioning service

## Tools and standards

- **Firmware Analysis**: Binwalk, FACT (Firmware Analysis and Comparison Tool), Firmwalker
- **Protocol Testing**: Killerbee (Zigbee), BtleJuice (BLE), MQTT Explorer, CoAP fuzzer
- **Standards**: OWASP IoT Top 10 2018, NIST IR 8259 (IoT device cybersecurity), ETSI EN 303 645 (consumer IoT security), IEC 62443 (industrial IoT)
