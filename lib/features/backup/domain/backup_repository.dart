/// Exports and restores the complete on-device dataset (FR-005, FR-006).
///
/// Both operations are local and never contact the network. Restore is atomic:
/// it either fully replaces the dataset or leaves the store unchanged.
abstract interface class BackupRepository {
  /// Serializes every entity to a single JSON document the user can store
  /// outside the app (FR-005).
  Future<Map<String, dynamic>> export();

  /// Restores the complete dataset from [json], atomically replacing all
  /// existing data (FR-006).
  ///
  /// A malformed or version-incompatible document is rejected before any write,
  /// and a failure mid-restore rolls back so previously committed data survives
  /// (NFR-004).
  Future<void> import(Map<String, dynamic> json);
}
