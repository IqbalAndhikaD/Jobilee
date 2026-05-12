import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jobilee/rsc/log.dart';

class JobService {
  static final _supabase = Supabase.instance.client;

  // ─────────────────────────────────────────
  // Job Vacations
  // ─────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getAllJobs() async {
    try {
      final result = await _supabase.from('job_vacations').select();
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      AppLog.info('getAllJobs error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getJobById(String jobId) async {
    try {
      final result = await _supabase
          .from('job_vacations')
          .select()
          .eq('id', jobId)
          .maybeSingle();
      return result;
    } catch (e) {
      AppLog.info('getJobById error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────
  // Job Applications
  // ─────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getMyApplications(
      String userId) async {
    try {
      final result = await _supabase
          .from('job_applications')
          .select()
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      AppLog.info('getMyApplications error: $e');
      return [];
    }
  }

  static Future<int> getJobApplicantCount(String jobId) async {
    try {
      final result = await _supabase
          .from('job_applications')
          .select()
          .eq('job_id', jobId); // ✅ was: job_vacation_id
      return result.length;
    } catch (e) {
      AppLog.info('getJobApplicantCount error: $e');
      return 0;
    }
  }

  static Future<bool> isJobApplied(String userId, String jobId) async {
    try {
      final result = await _supabase
          .from('job_applications')
          .select()
          .eq('user_id', userId)
          .eq('job_id', jobId); // ✅ was: job_vacation_id
      return result.isNotEmpty;
    } catch (e) {
      AppLog.info('isJobApplied error: $e');
      return false;
    }
  }

  static Future<bool> applyJob(String userId, String jobId) async {
    try {
      await _supabase.from('job_applications').insert({
        'user_id': userId,
        'job_id': jobId, // ✅ was: job_vacation_id
        'status': 'pending',
        'applied_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      AppLog.info('applyJob error: $e');
      return false;
    }
  }

  // ─────────────────────────────────────────
  // Saved Jobs
  // ─────────────────────────────────────────

  static Future<bool> isJobSaved(String userId, String jobId) async {
    try {
      final result = await _supabase
          .from('job_saved')
          .select()
          .eq('user_id', userId)
          .eq('job_id', jobId); // ✅ was: job_vacation_id
      return result.isNotEmpty;
    } catch (e) {
      AppLog.info('isJobSaved error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getSavedJobs(String userId) async {
    try {
      final result =
          await _supabase.from('job_saved').select().eq('user_id', userId);
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      AppLog.info('getSavedJobs error: $e');
      return [];
    }
  }

  static Future<String?> getSavedJobRowId(String userId, String jobId) async {
    try {
      final result = await _supabase
          .from('job_saved')
          .select('id')
          .eq('user_id', userId)
          .eq('job_id', jobId) // ✅ was: job_vacation_id
          .maybeSingle();
      return result?['id']?.toString();
    } catch (e) {
      AppLog.info('getSavedJobRowId error: $e');
      return null;
    }
  }

  static Future<bool> saveJob(String userId, String jobId) async {
    try {
      await _supabase.from('job_saved').insert({
        'user_id': userId,
        'job_id': jobId, // ✅ was: job_vacation_id
        'saved_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      AppLog.info('saveJob error: $e');
      return false;
    }
  }

  static Future<bool> unsaveJob(String userId, String jobId) async {
    try {
      await _supabase
          .from('job_saved')
          .delete()
          .eq('user_id', userId)
          .eq('job_id', jobId); // ✅ was: job_vacation_id
      return true;
    } catch (e) {
      AppLog.info('unsaveJob error: $e');
      return false;
    }
  }
}