const FtpDeploy = require("ftp-deploy");
const ftpDeploy = new FtpDeploy();
require("dotenv").config();

const config = {
    user: process.env.FTP_USER || process.env.FTP_USERNAME,
    password: process.env.FTP_PASSWORD,
    host: process.env.FTP_HOST,
    port: parseInt(process.env.FTP_PORT) || 21,
    localRoot: __dirname,
    remoteRoot: process.env.FTP_ROOT || "/public_html",
    include: [
        // Root files
        "artisan",
        "composer.json",
        "composer.lock",
        "package.json",
        "vite.config.js",
        "postcss.config.js",
        "tailwind.config.js",
        ".htaccess",
        ".gitignore",
        ".gitattributes",
        // Application directories
        "app/**",
        "bootstrap/**",
        "config/**",
        "database/factories/**",
        "database/migrations/**",
        "database/seeders/**",
        // Public (excluding storage symlink)
        "public/index.php",
        "public/robots.txt",
        "public/favicon.ico",
        "public/favicon.png",
        "public/build/**",
        // Resources & routes
        "resources/**",
        "routes/**",
        // Storage (skeleton only, not logs)
        "storage/app/**",
        "storage/framework/**",
        // GitHub workflows
        ".github/**",
    ],
    exclude: [
        "storage/logs/**",
        "storage/framework/cache/**",
        "bootstrap/cache/**",
        "database/database.sqlite",
    ],
    deleteRemote: false,
    forcePasv: true,
    sftp: false,
};

const vendorUpload = process.env.FTP_UPLOAD_VENDOR === "true";
if (vendorUpload) {
    config.include.push("vendor/**");
    console.log("⚠️  Including vendor/ folder (this may take a while)...");
} else {
    console.log("ℹ️  Skipping vendor/ — run 'composer install' on the server after deploy.");
}

console.log(`\n🚀 Starting FTP Deployment to ${config.host}`);
console.log(`📂 Remote Root: ${config.remoteRoot}\n`);

ftpDeploy
    .deploy(config)
    .then((res) => {
        console.log(`\n\n✅ Deployment complete! Uploaded ${res.length} files.`);
    })
    .catch((err) => {
        console.error("\n❌ Deployment error:", err);
        process.exit(1);
    });

ftpDeploy.on("uploading", function (data) {
    process.stdout.write(`\r📤 [${data.transferredFileCount}/${data.totalFilesCount}] ${String(data.filename).substring(0, 65).padEnd(65)}`);
});

ftpDeploy.on("upload-error", function (data) {
    console.error(`\n⚠️  Error: ${data.filename} — ${data.err}`);
});
