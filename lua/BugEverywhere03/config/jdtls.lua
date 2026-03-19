
-- Hàm lấy các đường dẫn cần thiết để khởi động JDTLS
local function get_jdtls()
    -- Path of jdtls 
    local jdtls_path = "/home/bug-every-where-03/.local/share/nvim/mason/packages/jdtls"
    -- Tìm file .jar khởi động language server
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    -- Mặc định là linux cho các hệ điều hành còn lại
    SYSTEM = "linux"
    -- Đường dẫn đến thư mục cấu hình theo OS
    local config = jdtls_path .. "/config_" .. SYSTEM
    -- Đường dẫn đến Lombok jar — cần thiết nếu project sử dụng Lombok annotations
    -- (@Getter, @Setter, @Builder, v.v.)
    local lombok = jdtls_path .. "/lombok.jar"

    return launcher, config, lombok
end

-- Hàm thu thập các jar bundle bổ sung cho debug và testing
local function get_bundles()

    -- ── Debug Adapter ──────────────────────────────────────────
    local java_debug_path = "/home/bug-every-where-03/.local/share/nvim/mason/packages/java-debug-adapter"

    -- Khởi tạo danh sách bundles với debug plugin jar
    -- Tham số `1` trong glob() nghĩa là trả về kết quả dưới dạng string thay vì list
    local bundles = {
        vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
    }

    -- ── Test Adapter ───────────────────────────────────────────
    local java_test_path = "home/bug-every-where-03/.local/share/nvim/mason/packages/java-test"

    -- Thêm tất cả các jar trong thư mục server của java-test vào bundles
    -- vim.split() tách chuỗi glob thành list các đường dẫn riêng lẻ
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

    return bundles
end

-- Hàm tạo đường dẫn workspace riêng cho từng project
-- JDTLS cần workspace để lưu trữ metadata, index, và cache của project
local function get_workspace()
    local home = os.getenv("HOME")
    -- Thư mục gốc chứa tất cả các workspace
    local workspace_path = home .. "/Dev/BugEveryWhere03/"
    -- Lấy tên project từ tên thư mục hiện tại
    -- `:p:h:t` — :p = full path, :h = bỏ phần cuối, :t = lấy tên thư mục cuối cùng
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    -- Workspace cuối cùng sẽ là: ~/code/workspace/<tên-project>
    local workspace_dir = workspace_path .. project_name
    return workspace_dir
end

-- Hàm đăng ký các keymaps và commands đặc thù cho Java
-- Được gọi một lần sau khi JDTLS attach vào buffer
local function java_keymaps(bufnr)
    -- ── Vim Commands ───────────────────────────────────────────
    -- Đăng ký lệnh :JdtCompile để biên dịch project
    vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
    -- Đăng ký lệnh :JdtUpdateConfig để cập nhật cấu hình project
    vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
    -- Đăng ký lệnh :JdtBytecode để decompile bytecode về Java source (dùng fernflower)
    vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
    -- Đăng ký lệnh :JdtJshell để mở Java REPL shell tương tác
    vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

    -- Gắn keymap vào buffer hiện tại, tránh ảnh hưởng đến các buffer khác
    local opts = { buffer = bufnr }

    -- ── Code Actions ───────────────────────────────────────────
    -- Tổ chức lại import statements
    vim.keymap.set('n', '<leader>Jo',
        "<Cmd>lua require('jdtls').organize_imports()<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava [O]rganize Imports" }))

    -- Extract đoạn code đang ở dưới cursor thành một biến mới
    vim.keymap.set('n', '<leader>Jv',
        "<Cmd>lua require('jdtls').extract_variable()<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava Extract [V]ariable" }))

    -- Extract đoạn code đang được chọn thành một biến mới (visual mode)
    vim.keymap.set('v', '<leader>Jv',
        "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava Extract [V]ariable" }))

    -- Extract đoạn code đang ở dưới cursor thành một hằng số static (normal mode)
    vim.keymap.set('n', '<leader>JC',
        "<Cmd>lua require('jdtls').extract_constant()<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava Extract [C]onstant" }))

    -- Extract đoạn code đang được chọn thành một hằng số static (visual mode)
    vim.keymap.set('v', '<leader>JC',
        "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava Extract [C]onstant" }))

    -- Chạy test method gần con trỏ nhất (normal mode)
    vim.keymap.set('n', '<leader>Jt',
        "<Cmd>lua require('jdtls').test_nearest_method()<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava [T]est Method" }))

    -- Chạy test method đang được chọn (visual mode)
    vim.keymap.set('v', '<leader>Jt',
        "<Esc><Cmd>lua require('jdtls').test_nearest_method(true)<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava [T]est Method" }))

    -- Chạy toàn bộ test suite của class hiện tại
    vim.keymap.set('n', '<leader>JT',
        "<Cmd>lua require('jdtls').test_class()<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava Test [T]est Class" }))

    -- Cập nhật cấu hình project
    vim.keymap.set('n', '<leader>Jc',
        "<Cmd>JdtUpdateConfig<CR>",
        vim.tbl_extend("force", opts, { desc = "[J]ava [C]onfig Update" }))
end

-- Khởi tạo và attach JDTLS vào buffer Java hiện tại
local function setup_jdtls()
    local jdtls = require("jdtls")

    -- Thu thập tất cả thông tin cần thiết
    local launcher, os_config, lombok = get_jdtls()
    local workspace_dir = get_workspace()
    local bundles = get_bundles()

    -- Xác định root directory của project bằng cách tìm các marker file
    -- JDTLS cần biết root để index toàn bộ project đúng cách
    local root_dir = jdtls.setup.find_root(
        { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
    )

    -- ── Capabilities ───────────────────────────────────────────
    -- "force" nghĩa là giá trị sau sẽ ghi đè giá trị trước nếu trùng key
    -- Deep extend đảm bảo các nested table được merge đúng cách, không bị ghi đè hoàn toàn
    local capabilities = vim.tbl_deep_extend("force",
        -- Capabilities mặc định của Neovim LSP client
        vim.lsp.protocol.make_client_capabilities(),
        -- Capabilities bổ sung từ nvim-cmp để hỗ trợ autocompletion
        require("cmp_nvim_lsp").default_capabilities(),
        -- Override một số capabilities theo nhu cầu của JDTLS
        {
            workspace = {
                -- Cho phép LSP server gửi workspace/configuration requests
                configuration = true
            },
            textDocument = {
                completion = {
                    -- Tắt snippet support vì JDTLS có cách xử lý riêng
                    snippetSupport = false
                }
            }
        }
    )

    -- Lấy extended capabilities của JDTLS 
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    -- Bật hỗ trợ resolve additional text edit
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    -- ── Command khởi động JDTLS ────────────────────────────────
    local cmd = {
        -- Dùng java executable từ PATH
        'java',
        -- Các flag bắt buộc để chạy Eclipse OSGi runtime
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        -- Bật logging đầy đủ 
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        -- Giới hạn bộ nhớ heap tối đa là 2GB 
        '-Xmx2g',
        -- Cho phép truy cập tất cả modules của JDK
        '--add-modules=ALL-SYSTEM',
        -- Mở các package nội bộ của java.base để JDTLS có thể truy cập
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        -- Inject Lombok như một Java agent để xử lý annotations trước khi compile
        '-javaagent:' .. lombok,
        -- Chỉ định file jar khởi động JDTLS
        '-jar', launcher,
        -- Chỉ định thư mục config theo OS
        '-configuration', os_config,
        -- Chỉ định workspace directory cho project này
        '-data', workspace_dir
    }

    -- ── Settings của JDTLS server ──────────────────────────────
    local settings = {
        java = {
            -- Cấu hình định dạng code tự động
            format = {
                enabled = true,
                settings = {
                    -- Tải tại: https://github.com/google/styleguide
                    url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
                    profile = "GoogleStyle"
                }
            },
            -- Tự động tải source code của Eclipse dependencies
            eclipse = {
                downloadSource = true
            },
            -- Tự động tải source code của Maven dependencies
            maven = {
                downloadSources = true
            },
            -- Hiển thị signature (tham số) khi gọi method
            signatureHelp = {
                enabled = true
            },
            -- Dùng fernflower decompiler để xem source khi không có source jar
            -- Thay thế: cfr, procyon
            contentProvider = {
                preferred = "fernflower"
            },
            -- Tự động tổ chức imports mỗi khi lưu file
            saveActions = {
                organizeImports = true
            },
            -- Cấu hình autocompletion
            completion = {
                -- Danh sách static methods được ưu tiên gợi ý khi import
                -- Thứ tự trong list ảnh hưởng đến độ ưu tiên
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                -- Lọc bỏ các package không muốn thấy trong gợi ý import
                -- Các package internal/deprecated thường gây nhầm lẫn
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",  -- AWT thường không dùng trong Java hiện đại
                    "jdk.*",       -- Internal JDK APIs
                    "sun.*",       -- Deprecated Sun APIs
                },
                -- Thứ tự sắp xếp import statements theo nhóm package
                importOrder = {
                    "java",    -- Java standard library luôn đứng đầu
                    "jakarta", -- Jakarta EE 
                    "javax",   -- Java EE cũ
                    "javafx",
                    "com",
                    "org",
                }
            },
            sources = {
                -- Số lượng class tối thiểu từ cùng package trước khi dùng wildcard import (*)
                -- Đặt 9999 để tránh tự động dùng wildcard import
                organizeImports = {
                    starThreshold = 9999,
                    staticThreshold = 9999
                }
            },
            -- Cấu hình cách generate code tự động
            codeGeneration = {
                -- Template cho toString() method — format giống JSON để dễ đọc
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                -- Dùng java.util.Objects cho hashCode() và equals() (Java 7+)
                -- Tốt hơn so với implement thủ công
                hashCodeEquals = {
                    useJava7Objects = true
                },
                -- Luôn dùng block braces {} trong code được generate (tránh lỗi)
                useBlocks = true
            },
            -- Hỏi developer trước khi tự động cập nhật build config
            -- Tránh trường hợp JDTLS tự ý thay đổi pom.xml/build.gradle
            configuration = {
                updateBuildConfiguration = "interactive"
            },
            -- Hiển thị số lượng references ngay trên method/class (Code Lens)
            referencesCodeLens = {
                enabled = true
            },
            -- Hiển thị tên tham số inline khi gọi method (Inlay Hints)
            -- Ví dụ: someMethod(/* name: */ "John", /* age: */ 25)
            inlayHints = {
                parameterNames = {
                    enabled = "all" -- "none" | "literals" | "all"
                }
            }
        }
    }

    -- Đóng gói bundles và extendedClientCapabilities để truyền vào JDTLS
    local init_options = {
        -- Các jar bổ sung cho debug adapter và test runner
        bundles = bundles,
        -- Các tính năng mở rộng đặc thù của Eclipse/JDTLS
        extendedClientCapabilities = extendedClientCapabilities
    }

    -- ── on_attach: chạy sau khi JDTLS attach thành công vào buffer ────
    -- `client` — LSP client object (có thể dùng để kiểm tra capabilities)
    -- `bufnr`  — buffer number của file Java đang được mở
    local on_attach = function(_, bufnr)
        -- Đăng ký tất cả keymaps và commands Java-specific
        java_keymaps(bufnr)

        -- Khởi động Debug Adapter Protocol (DAP) integration
        jdtls.setup_dap({ hotcodereplace = 'auto' })

        -- Tự động tìm và đăng ký các main class để DAP biết điểm khởi đầu khi debug
        require('jdtls.dap').setup_dap_main_class_configs()

        -- Refresh Code Lens ngay khi attach để hiển thị reference counts
        vim.lsp.codelens.refresh({ bufnr = bufnr })

        -- Tạo augroup riêng cho mỗi buffer để tránh duplicate autocmds
        -- Nếu không có group, mỗi lần attach sẽ tạo thêm một autocmd mới
        -- dẫn đến codelens.refresh() bị gọi nhiều lần sau mỗi lần lưu
        local group = vim.api.nvim_create_augroup("jdtls_codelens_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            -- Dùng `buffer` thay vì `pattern = {"*.java"}` để chính xác hơn
            -- Chỉ trigger cho đúng buffer này, không phải mọi file .java
            buffer = bufnr,
            callback = function()
                -- pcall để bắt lỗi nếu LSP chưa sẵn sàng, tránh crash Neovim
                pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
            end
        })
    end

    -- Tổng hợp toàn bộ config và khởi động JDTLS
    -- start_or_attach() sẽ tự động tái sử dụng server đang chạy nếu có
    local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = settings,
        capabilities = capabilities,
        init_options = init_options,
        on_attach = on_attach
    }

    jdtls.start_or_attach(config)
end

return {
    setup_jdtls = setup_jdtls,
}

