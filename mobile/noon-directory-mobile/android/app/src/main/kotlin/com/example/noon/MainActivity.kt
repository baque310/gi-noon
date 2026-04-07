package h.noon.app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.InputStream
import java.io.OutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "permissions_helper"
    private val REQUEST_CODE_OPEN_DOCUMENT_TREE = 4242
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestDownloadsAccess" -> {
                    if (pendingResult != null) {
                        result.error("ALREADY_RUNNING", "A request is already running", null)
                        return@setMethodCallHandler
                    }
                    pendingResult = result
                    launchDownloadsTreePicker()
                }
                "listDownloadsFiles" -> {
                    val res = listFilesInDownloads()
                    result.success(res)
                }
                "createFileInDownloads" -> {
                    val filename = call.argument<String>("name") ?: ""
                    val mime = call.argument<String>("mime") ?: "application/octet-stream"
                    val uriStr = createFileInDownloads(filename, mime)
                    result.success(uriStr)
                }
                "writeFileToDownloads" -> {
                    val uriStr = call.argument<String>("uri") ?: ""
                    val base64Data = call.argument<String>("base64") ?: ""
                    val ok = writeFileFromBase64(uriStr, base64Data)
                    result.success(ok)
                }
                "readFileFromDownloads" -> {
                    val uriStr = call.argument<String>("uri") ?: ""
                    val base64 = readFileToBase64(uriStr)
                    result.success(base64)
                }
                "deleteFileFromDownloads" -> {
                    val uriStr = call.argument<String>("uri") ?: ""
                    val ok = deleteFileFromDownloads(uriStr)
                    result.success(ok)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun launchDownloadsTreePicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or
                     Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                     Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // Hint to open Downloads (best-effort)
                putExtra(DocumentsContract.EXTRA_INITIAL_URI,
                    Uri.parse("content://com.android.externalstorage.documents/document/primary:Download"))
            }
        }
        startActivityForResult(intent, REQUEST_CODE_OPEN_DOCUMENT_TREE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_CODE_OPEN_DOCUMENT_TREE) {
            val res = pendingResult ?: run {
                super.onActivityResult(requestCode, resultCode, data)
                return
            }

            if (resultCode == Activity.RESULT_OK && data != null) {
                val treeUri = data.data
                if (treeUri != null) {
                    try {
                        val takeFlags = (data.flags and
                                (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION))
                        contentResolver.takePersistableUriPermission(treeUri, takeFlags)
                        // Save URI
                        val prefs = getSharedPreferences("saf_prefs", Context.MODE_PRIVATE)
                        prefs.edit().putString("downloads_tree_uri", treeUri.toString()).apply()
                        res.success(true)
                    } catch (ex: Exception) {
                        res.success(false)
                    }
                } else {
                    res.success(false)
                }
            } else {
                res.success(false)
            }

            pendingResult = null
            return
        }

        super.onActivityResult(requestCode, resultCode, data)
    }

    // HELPERS

    private fun getSavedTreeUri(): Uri? {
        val prefs = getSharedPreferences("saf_prefs", Context.MODE_PRIVATE)
        val s = prefs.getString("downloads_tree_uri", null) ?: return null
        return Uri.parse(s)
    }

    // List child documents under persisted tree: returns List<Map<String,String>> as JSONable list
    private fun listFilesInDownloads(): List<Map<String, String>> {
        val tree = getSavedTreeUri() ?: return emptyList()
        val childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(tree,
            DocumentsContract.getTreeDocumentId(tree))
        val cols = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
            DocumentsContract.Document.COLUMN_SIZE
        )

        val list = mutableListOf<Map<String, String>>()
        contentResolver.query(childrenUri, cols, null, null, null)?.use { cursor ->
            while (cursor.moveToNext()) {
                val docId = cursor.getString(cursor.getColumnIndexOrThrow(cols[0]))
                val name = cursor.getString(cursor.getColumnIndexOrThrow(cols[1]))
                val mime = cursor.getString(cursor.getColumnIndexOrThrow(cols[2]))
                val size = try { cursor.getString(cursor.getColumnIndexOrThrow(cols[3])) } catch (e: Exception) { null }

                val docUri = DocumentsContract.buildDocumentUriUsingTree(tree, docId)
                list.add(mapOf(
                    "documentId" to docId,
                    "name" to (name ?: ""),
                    "mime" to (mime ?: ""),
                    "size" to (size ?: ""),
                    "uri" to docUri.toString()
                ))
            }
        }
        return list
    }

    // Create a document under the persisted tree. Returns uri string or null on failure
    private fun createFileInDownloads(displayName: String, mimeType: String): String? {
        val tree = getSavedTreeUri() ?: return null
        return try {
            // Use tree as parent; on some devices you may need buildDocumentUriUsingTree(tree, treeId)
            val created = DocumentsContract.createDocument(contentResolver, tree, mimeType, displayName)
            created?.toString()
        } catch (e: Exception) {
            null
        }
    }

    // Write base64 bytes to a document Uri (must be exact document Uri). Returns boolean success.
    private fun writeFileFromBase64(uriString: String, base64Data: String): Boolean {
        return try {
            val uri = Uri.parse(uriString)
            val bytes = Base64.decode(base64Data, Base64.DEFAULT)
            contentResolver.openOutputStream(uri)?.use { out: OutputStream ->
                out.write(bytes)
                out.flush()
            } ?: return false
            true
        } catch (e: Exception) {
            false
        }
    }

    // Read document content as base64 string
    private fun readFileToBase64(uriString: String): String? {
        return try {
            val uri = Uri.parse(uriString)
            val baos = ByteArrayOutputStream()
            contentResolver.openInputStream(uri)?.use { input: InputStream ->
                val buffer = ByteArray(8192)
                var read: Int
                while (input.read(buffer).also { read = it } != -1) {
                    baos.write(buffer, 0, read)
                }
            } ?: return null
            Base64.encodeToString(baos.toByteArray(), Base64.NO_WRAP)
        } catch (e: Exception) {
            null
        }
    }

    // Delete a document by document URI
    private fun deleteFileFromDownloads(uriString: String): Boolean {
        return try {
            val uri = Uri.parse(uriString)
            DocumentsContract.deleteDocument(contentResolver, uri)
            true
        } catch (e: Exception) {
            false
        }
    }
}
