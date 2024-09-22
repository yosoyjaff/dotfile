#!/bin/bash

# Función para mostrar emojis con los mensajes
function echo_with_emoji() {
    echo -e "$1 $2"
}

# Verifica si git está instalado
if ! command -v git &> /dev/null
then
    echo_with_emoji "🚫" "Git no está instalado. Por favor, instala Git para continuar."
    exit 1
fi

# Actualiza el sistema
#echo_with_emoji "🔄" "Actualizando sistema..."
#softwareupdate --all --install --force

# Instalar Homebrew
if ! command -v brew &> /dev/null
then
    echo_with_emoji "🍺" "Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo_with_emoji "✅" "Homebrew ya está instalado"
fi

# Actualiza brew y verifica el estado
echo_with_emoji "🍻" "Actualizando Homebrew..."
brew update

# Instalar Kitty (emulador de terminal)
if ! command -v kitty &> /dev/null
then
    echo_with_emoji "🐱" "Instalando Kitty..."
    brew install kitty
else
    echo_with_emoji "✅" "Kitty ya está instalado"
fi

# Instalar Micro (editor de texto de terminal)
if ! command -v micro &> /dev/null
then
    echo_with_emoji "✍️" "Instalando Micro..."
    brew install micro
else
    echo_with_emoji "✅" "Micro ya está instalado"
fi

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]
then
    echo_with_emoji "💻" "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
else
    echo_with_emoji "✅" "Oh My Zsh ya está instalado"
fi

# Instalar Powerlevel10k en ~/.config/p10k
P10K_DIR="$HOME/.config/p10k"

if [ ! -d "$P10K_DIR" ]
then
    echo_with_emoji "🎨" "Instalando Powerlevel10k en ~/.config/p10k..."
    mkdir -p "$P10K_DIR"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    # Cambiar el tema en el .zshrc
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="~\/.config\/p10k\/powerlevel10k"/' ~/.zshrc
else
    echo_with_emoji "✅" "Powerlevel10k ya está instalado en ~/.config/p10k"
fi
# Plugins para Oh My Zsh
PLUGINS_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh}/plugins

# Instalar plugins si no están instalados
plugins=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
)

for plugin in "${plugins[@]}"; do
    plugin_name=$(basename "$plugin")
    if [ ! -d "$PLUGINS_DIR/$plugin_name" ]; then
        echo_with_emoji "🔌" "Instalando el plugin $plugin_name..."
        git clone "https://github.com/$plugin.git" "$PLUGINS_DIR/$plugin_name"
    else
        echo_with_emoji "✅" "El plugin $plugin_name ya está instalado"
    fi
done

# Añadir los plugins al archivo .zshrc
if ! grep -q "plugins=(" ~/.zshrc; then
    echo "plugins=(" >> ~/.zshrc
fi

for plugin in "${plugins[@]}"; do
    plugin_name=$(basename "$plugin")
    if ! grep -q "$plugin_name" ~/.zshrc; then
        echo "Añadiendo $plugin_name al archivo .zshrc..."
        sed -i '' "s/^plugins=(/& $plugin_name/" ~/.zshrc
    fi
done

# Instalar lsd
if ! command -v lsd &> /dev/null
then
    echo_with_emoji "🔍" "Instalando lsd..."
    brew install lsd
else
    echo_with_emoji "✅" "lsd ya está instalado"
fi

# Instalar bat
if ! command -v bat &> /dev/null
then
    echo_with_emoji "🐱" "Instalando bat..."
    brew install bat
else
    echo_with_emoji "✅" "bat ya está instalado"
fi

# Añadir alias a .zshrc
if ! grep -q "alias ls='lsd'" ~/.zshrc; then
    echo_with_emoji "🔧" "Añadiendo alias para lsd..."
    echo "alias ls='lsd'" >> ~/.zshrc
fi

if ! grep -q "alias cat='bat'" ~/.zshrc; then
    echo_with_emoji "🔧" "Añadiendo alias para bat..."
    echo "alias cat='bat'" >> ~/.zshrc
fi

# Aplicar cambios
echo_with_emoji "⚙️" "Aplicando cambios..."
source ~/.zshrc
echo_with_emoji "🎉" "Instalación completada. Por favor, reinicia tu terminal."