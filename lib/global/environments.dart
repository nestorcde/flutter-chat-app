



import 'dart:io';

class Environment {
   Uri apiUrl(String endpoint) =>    Uri(
                          scheme: 'http',
                          host: Platform.isAndroid ? '10.0.2.2' : 'localhost',
                          port: 3000,
                          path: '/api'+endpoint
                        );
   Uri socketUrl() => Uri(
                          scheme: 'http',
                          host: Platform.isAndroid ? '10.0.2.2' : 'localhost',
                          port: 3000,
                        );
}