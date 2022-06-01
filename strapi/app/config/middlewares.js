module.exports = ({ env }) => ([
  'strapi::errors',
  // This is the default security entry
  // 'strapi::security',
  'strapi::cors',
  'strapi::poweredBy',
  'strapi::logger',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
  // Security entry for @strapi/provider-upload-aws-s3
  // See https://github.com/strapi/strapi/tree/master/packages/providers/upload-aws-s3
  {
    name: 'strapi::security',
    config: {
      contentSecurityPolicy: {
        useDefaults: true,
        directives: {
          'connect-src': ["'self'", 'https:'],
          'img-src': [
            "'self'",
            'data:',
            'blob:',
            'dl.airtable.com', // TODO: This is referenced in @strapi/provider-upload-aws-s3, is it required?
            `${env('AWS_BUCKET')}.s3.${env('AWS_REGION')}.amazonaws.com`,
          ],
          'media-src': [
            "'self'",
            'data:',
            'blob:',
            'dl.airtable.com', // TODO: This is referenced in @strapi/provider-upload-aws-s3, is it required?
            `${env('AWS_BUCKET')}.s3.${env('AWS_REGION')}.amazonaws.com`,
          ],
          upgradeInsecureRequests: null,
        },
      },
    },
  },
]);
